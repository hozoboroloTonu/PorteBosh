class ExamsTable {
  static const String tableName = 'exams';

  static const String colId = 'id';
  static const String colCourseId = 'course_id';
  static const String colTitle = 'title';
  static const String colStartsAt = 'starts_at';
  static const String colTotalMarks = 'total_marks';
  static const String colAcquiredMarks = 'acquired_marks';
  static const String colNotes = 'notes';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colId TEXT PRIMARY KEY,
      $colCourseId TEXT NOT NULL,
      $colTitle TEXT NOT NULL,
      $colStartsAt TEXT NOT NULL,
      $colTotalMarks REAL,
      $colAcquiredMarks REAL,
      $colNotes TEXT,
      $colCreatedAt TEXT NOT NULL,
      $colUpdatedAt TEXT NOT NULL,
      FOREIGN KEY ($colCourseId) REFERENCES courses (id) ON DELETE CASCADE
    );
  ''';
}
