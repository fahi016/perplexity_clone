// lib/services/chat_web_service.dart
import 'dart:async';
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_client/web_socket_client.dart';

import 'database_service.dart'; // ← the helper we wrote earlier

class ChatWebService {
  // ───────────────────────── singleton
  static final ChatWebService _instance = ChatWebService._internal();
  factory ChatWebService() => _instance;
  ChatWebService._internal();

  // ───────────────────────── socket & streams
  WebSocket? _socket;

  final _searchResultCtrl  = StreamController<Map<String, dynamic>>.broadcast();
  final _contentCtrl       = StreamController<Map<String, dynamic>>.broadcast();
  final _youtubeResultCtrl = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get searchResultStream  =>
      _searchResultCtrl.stream;
  Stream<Map<String, dynamic>> get contentStream       =>
      _contentCtrl.stream;
  Stream<Map<String, dynamic>> get youtubeResultStream =>
      _youtubeResultCtrl.stream;

  // ───────────────────────── DB helpers
  String?          _currentChatId;
  final StringBuffer _answerBuffer  = StringBuffer();
  List<dynamic>      _sources       = [];
  List<dynamic>      _youtube       = [];

  // ───────────────────────── connect once at app start
  void connect() {
    _socket ??=
        WebSocket(Uri.parse('ws://localhost:8000/ws/chat'));

    _socket!.messages.listen(
      _handleMessage,
      onDone: _finaliseChatRow,     // ← fires when server closes the WS
      cancelOnError: true,
    );
  }

  // ───────────────────────── send a new question
  void chat(String query) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    _socket?.send(jsonEncode({
      'query':   query,
      'user_id': userId,            
    }));
  }

  // ───────────────────────── message handler
  void _handleMessage(dynamic raw) {
    final data = jsonDecode(raw as String);

    switch (data['type']) {
      case 'chat_id':
        _currentChatId = data['data'];
        break;

      case 'search_result':
        _sources = data['data'];
        _searchResultCtrl.add(data);
        break;

      case 'youtube_result':
        _youtube = data['data'];
        _youtubeResultCtrl.add(data);
        break;

      case 'content':
        final chunk = data['data'] as String;
        _answerBuffer.write(chunk);
        _contentCtrl.add(data);

        if (_currentChatId != null) {
          DatabaseService.appendAnswerChunk(
            chatId: _currentChatId!,
            chunk: chunk,
          );
        }
        break;

      case 'done':                   // optional – only if server sends
        _finaliseChatRow();
        break;
    }
  }

  // ───────────────────────── final DB update
  void _finaliseChatRow() {
    if (_currentChatId == null) return;

    DatabaseService.finishChat(
      chatId:     _currentChatId!,
      answerFull: _answerBuffer.toString(),
      sources:    _sources,
      youtube:    _youtube,
    );

    // reset buffers for next session
    _currentChatId = null;
    _answerBuffer.clear();
    _sources = [];
    _youtube = [];
  }
}
