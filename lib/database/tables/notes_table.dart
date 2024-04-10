class NotesTable {
  static const String tableName = 'notes';

  static const String colId = 'id';
  static const String colCourseId = 'course_id';
  static const String colTopicId = 'topic_id';
  static const String colTitle = 'title';
  static const String colBody = 'body';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colId TEXT PRIMARY KEY,
      $colCourseId TEXT NOT NULL,
      $colTopicId TEXT,
      $colTitle TEXT NOT NULL,
      $colBody TEXT NOT NULL,
      $colCreatedAt TEXT NOT NULL,
      $colUpdatedAt TEXT NOT NULL,
      FOREIGN KEY ($colCourseId) REFERENCES courses (id) ON DELETE CASCADE,
      FOREIGN KEY ($colTopicId) REFERENCES topics (id) ON DELETE SET NULL
    );
  ''';
}
