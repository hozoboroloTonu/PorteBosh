class TopicsTable {
  static const String tableName = 'topics';

  static const String colId = 'id';
  static const String colCourseId = 'course_id';
  static const String colName = 'name';
  static const String colDescription = 'description';
  static const String colSortOrder = 'sort_order';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colId TEXT PRIMARY KEY,
      $colCourseId TEXT NOT NULL,
      $colName TEXT NOT NULL,
      $colDescription TEXT,
      $colSortOrder INTEGER NOT NULL DEFAULT 0,
      $colCreatedAt TEXT NOT NULL,
      $colUpdatedAt TEXT NOT NULL,
      FOREIGN KEY ($colCourseId) REFERENCES courses (id) ON DELETE CASCADE
    );
  ''';
}
