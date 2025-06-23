class ChatModel {
  final String id;
  final String userId;
  final String question;
  final DateTime createdAt;
  final List<dynamic>? sources;
  final List<dynamic>? youtube;
  final List<dynamic>? answerChunks;
  final String? answerFull;
  final String? preview;

  ChatModel({
    required this.id,
    required this.userId,
    required this.question,
    required this.createdAt,
    this.sources,
    this.youtube,
    this.answerChunks,
    this.answerFull,
    this.preview,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        question: json['question'],
        createdAt: DateTime.parse(json['created_at']),
        sources: json['sources'],
        youtube: json['youtube'],
        answerChunks: json['answer_chunks'],
        answerFull: json['answer_full'],
        preview: json['preview'],
      );
}
