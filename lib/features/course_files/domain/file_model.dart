class CourseFile {
  final String id;
  final String originalName;
  final String storedRelativePath;
  final String mimeType;
  final String extension;
  final int sizeBytes;
  final String courseId;
  final String? topicId;
  final bool isFavorite;
  final DateTime importedAt;
  final DateTime? lastOpenedAt;
  final int? lastReadPage;
  final String? description;

  const CourseFile({
    required this.id,
    required this.originalName,
    required this.storedRelativePath,
    required this.mimeType,
    required this.extension,
    required this.sizeBytes,
    required this.courseId,
    this.topicId,
    this.isFavorite = false,
    required this.importedAt,
    this.lastOpenedAt,
    this.lastReadPage,
    this.description,
  });

  bool get isPdf => extension.toLowerCase() == '.pdf';
  bool get isImage => ['.jpg', '.jpeg', '.png', '.webp'].contains(extension.toLowerCase());

  CourseFile copyWith({
    String? id,
    String? originalName,
    String? storedRelativePath,
    String? mimeType,
    String? extension,
    int? sizeBytes,
    String? courseId,
    String? topicId,
    bool? isFavorite,
    DateTime? importedAt,
    DateTime? lastOpenedAt,
    int? lastReadPage,
    String? description,
  }) {
    return CourseFile(
      id: id ?? this.id,
      originalName: originalName ?? this.originalName,
      storedRelativePath: storedRelativePath ?? this.storedRelativePath,
      mimeType: mimeType ?? this.mimeType,
      extension: extension ?? this.extension,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      courseId: courseId ?? this.courseId,
      topicId: topicId ?? this.topicId,
      isFavorite: isFavorite ?? this.isFavorite,
      importedAt: importedAt ?? this.importedAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      lastReadPage: lastReadPage ?? this.lastReadPage,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'original_name': originalName,
      'stored_relative_path': storedRelativePath,
      'mime_type': mimeType,
      'extension': extension,
      'size_bytes': sizeBytes,
      'course_id': courseId,
      'topic_id': topicId,
      'is_favorite': isFavorite ? 1 : 0,
      'imported_at': importedAt.toIso8601String(),
      'last_opened_at': lastOpenedAt?.toIso8601String(),
      'last_read_page': lastReadPage,
      'description': description,
    };
  }

  factory CourseFile.fromMap(Map<String, dynamic> map) {
    return CourseFile(
      id: map['id'] as String,
      originalName: map['original_name'] as String,
      storedRelativePath: map['stored_relative_path'] as String,
      mimeType: map['mime_type'] as String,
      extension: map['extension'] as String,
      sizeBytes: map['size_bytes'] as int,
      courseId: map['course_id'] as String,
      topicId: map['topic_id'] as String?,
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
      importedAt: DateTime.parse(map['imported_at'] as String),
      lastOpenedAt: map['last_opened_at'] != null ? DateTime.parse(map['last_opened_at'] as String) : null,
      lastReadPage: map['last_read_page'] as int?,
      description: map['description'] as String?,
    );
  }
}
