class Note {
  final String id;
  final String courseId;
  final String? topicId;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.courseId,
    this.topicId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  Note copyWith({
    String? id,
    String? courseId,
    String? topicId,
    String? title,
    String? body,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      topicId: topicId ?? this.topicId,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'topic_id': topicId,
      'title': title,
      'body': body,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String,
      courseId: map['course_id'] as String,
      topicId: map['topic_id'] as String?,
      title: map['title'] as String,
      body: map['body'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
