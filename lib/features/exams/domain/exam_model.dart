class Exam {
  final String id;
  final String courseId;
  final String title;
  final DateTime startsAt;
  final double? totalMarks;
  final double? acquiredMarks;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Exam({
    required this.id,
    required this.courseId,
    required this.title,
    required this.startsAt,
    this.totalMarks,
    this.acquiredMarks,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isCompleted => startsAt.isBefore(DateTime.now());

  Exam copyWith({
    String? id,
    String? courseId,
    String? title,
    DateTime? startsAt,
    double? totalMarks,
    double? acquiredMarks,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exam(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      startsAt: startsAt ?? this.startsAt,
      totalMarks: totalMarks ?? this.totalMarks,
      acquiredMarks: acquiredMarks ?? this.acquiredMarks,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'starts_at': startsAt.toIso8601String(),
      'total_marks': totalMarks,
      'acquired_marks': acquiredMarks,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'] as String,
      courseId: map['course_id'] as String,
      title: map['title'] as String,
      startsAt: DateTime.parse(map['starts_at'] as String),
      totalMarks: (map['total_marks'] as num?)?.toDouble(),
      acquiredMarks: (map['acquired_marks'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
