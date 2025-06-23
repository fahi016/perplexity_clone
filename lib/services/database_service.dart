// lib/services/database_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_model.dart';

class DatabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  static final _chats = _client.from('chats');

  /// Create a new chat row and return its ID.
  static Future<String> createChat(String question) async {
    final userId = _client.auth.currentUser!.id;
    final res = await _chats
        .insert({
          'user_id': userId,
          'question': question,
          'preview': question.substring(0, 60),
        })
        .select()
        .single();
    return res['id'] as String;
  }

  /// Append a single token / chunk to `answer_chunks`
  static Future<void> appendAnswerChunk({
    required String chatId,
    required String chunk,
  }) async {
    await _client.rpc('append_answer_chunk', params: {
      'chat_id': chatId,
      'chunk': chunk,
    });
  }

  /// When the streaming is done, save final data
  static Future<void> finishChat({
    required String chatId,
    required String answerFull,
    required List<dynamic> sources,
    required List<dynamic> youtube,
  }) async {
    await _chats.update({
      'answer_full': answerFull,
      'sources': sources,
      'youtube': youtube,
    }).eq('id', chatId);
  }

  /// Stream my chats (latest first)
  static Stream<List<ChatModel>> streamMyChats() {
    final userId = _client.auth.currentUser!.id;
    return _chats
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((rows) => rows.map((r) => ChatModel.fromJson(r)).toList());
  }
}
