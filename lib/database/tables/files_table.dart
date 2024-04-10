class FilesTable {
  static const String tableName = 'files';

  static const String colId = 'id';
  static const String colOriginalName = 'original_name';
  static const String colStoredRelativePath = 'stored_relative_path';
  static const String colMimeType = 'mime_type';
  static const String colExtension = 'extension';
  static const String colSizeBytes = 'size_bytes';
  static const String colCourseId = 'course_id';
  static const String colTopicId = 'topic_id';
  static const String colIsFavorite = 'is_favorite';
  static const String colImportedAt = 'imported_at';
  static const String colLastOpenedAt = 'last_opened_at';
  static const String colLastReadPage = 'last_read_page';
  static const String colDescription = 'description';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colId TEXT PRIMARY KEY,
      $colOriginalName TEXT NOT NULL,
      $colStoredRelativePath TEXT NOT NULL,
      $colMimeType TEXT NOT NULL,
      $colExtension TEXT NOT NULL,
      $colSizeBytes INTEGER NOT NULL,
      $colCourseId TEXT NOT NULL,
      $colTopicId TEXT,
      $colIsFavorite INTEGER NOT NULL DEFAULT 0,
      $colImportedAt TEXT NOT NULL,
      $colLastOpenedAt TEXT,
      $colLastReadPage INTEGER,
      $colDescription TEXT,
      FOREIGN KEY ($colCourseId) REFERENCES courses (id) ON DELETE CASCADE,
      FOREIGN KEY ($colTopicId) REFERENCES topics (id) ON DELETE SET NULL
    );
  ''';
}
