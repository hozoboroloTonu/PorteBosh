class CoursesTable {
  static const String tableName = 'courses';

  static const String colId = 'id';
  static const String colCode = 'code';
  static const String colName = 'name';
  static const String colInstructor = 'instructor';
  static const String colSemester = 'semester';
  static const String colCredits = 'credits';
  static const String colColorValue = 'color_value';
  static const String colDescription = 'description';
  static const String colIsArchived = 'is_archived';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colId TEXT PRIMARY KEY,
      $colCode TEXT,
      $colName TEXT NOT NULL,
      $colInstructor TEXT,
      $colSemester TEXT,
      $colCredits REAL,
      $colColorValue INTEGER NOT NULL,
      $colDescription TEXT,
      $colIsArchived INTEGER NOT NULL DEFAULT 0,
      $colCreatedAt TEXT NOT NULL,
      $colUpdatedAt TEXT NOT NULL
    );
  ''';
}
