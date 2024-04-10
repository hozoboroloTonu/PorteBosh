class RoutineSessionsTable {
  static const String tableName = 'weekly_class_sessions';

  static const String colId = 'id';
  static const String colCourseId = 'course_id';
  static const String colWeekday = 'weekday';
  static const String colStartMinute = 'start_minute';
  static const String colEndMinute = 'end_minute';
  static const String colTitleOrType = 'title_or_type';
  static const String colRoom = 'room';
  static const String colInstructor = 'instructor';
  static const String colNote = 'note';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colId TEXT PRIMARY KEY,
      $colCourseId TEXT NOT NULL,
      $colWeekday INTEGER NOT NULL,
      $colStartMinute INTEGER NOT NULL,
      $colEndMinute INTEGER NOT NULL,
      $colTitleOrType TEXT,
      $colRoom TEXT,
      $colInstructor TEXT,
      $colNote TEXT,
      $colCreatedAt TEXT NOT NULL,
      $colUpdatedAt TEXT NOT NULL,
      FOREIGN KEY ($colCourseId) REFERENCES courses (id) ON DELETE CASCADE
    );
  ''';

  static const String createIndexQuery = '''
    CREATE INDEX IF NOT EXISTS idx_routine_weekday ON $tableName ($colWeekday);
    CREATE INDEX IF NOT EXISTS idx_routine_course ON $tableName ($colCourseId);
  ''';
}
