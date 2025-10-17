/// Model representing a daily reflection entry
class Reflection {
  final String id;
  final String userId;
  final String content;
  final String questionText;
  final String? mood;
  final DateTime createdAt;

  Reflection({
    required this.id,
    required this.userId,
    required this.content,
    required this.questionText,
    this.mood,
    required this.createdAt,
  });

  /// Convert Reflection to Map for Supabase insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'question_text': questionText,
      'mood': mood,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create Reflection from Supabase Map
  factory Reflection.fromMap(Map<String, dynamic> map) {
    return Reflection(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      content: map['content'] as String,
      questionText: map['question_text'] as String,
      mood: map['mood'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Create a copy of this Reflection with updated fields
  Reflection copyWith({
    String? id,
    String? userId,
    String? content,
    String? questionText,
    String? mood,
    DateTime? createdAt,
  }) {
    return Reflection(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      questionText: questionText ?? this.questionText,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Reflection(id: $id, userId: $userId, questionText: $questionText, content: $content, mood: $mood, createdAt: $createdAt)';
  }
}
