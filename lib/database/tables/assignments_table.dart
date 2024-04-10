class AssignmentsTable {
  static const String tableName = 'assignments';

  static const String colId = 'id';
  static const String colCourseId = 'course_id';
  static const String colTitle = 'title';
  static const String colDescription = 'description';
  static const String colDeadlineAt = 'deadline_at';
  static const String colPriority = 'priority';
  static const String colStatus = 'status';
  static const String colEstimatedMinutes = 'estimated_minutes';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colId TEXT PRIMARY KEY,
      $colCourseId TEXT NOT NULL,
      $colTitle TEXT NOT NULL,
      $colDescription TEXT,
      $colDeadlineAt TEXT,
      $colPriority TEXT NOT NULL DEFAULT 'medium',
      $colStatus TEXT NOT NULL DEFAULT 'pending',
      $colEstimatedMinutes INTEGER,
      $colCreatedAt TEXT NOT NULL,
      $colUpdatedAt TEXT NOT NULL,
      FOREIGN KEY ($colCourseId) REFERENCES courses (id) ON DELETE CASCADE
    );
  ''';
}
