class ExamTopicProgressTable {
  static const String tableName = 'exam_topic_progress';

  static const String colId = 'id';
  static const String colExamId = 'exam_id';
  static const String colTopicId = 'topic_id';
  static const String colStatus = 'status';
  static const String colNotes = 'notes';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colId TEXT PRIMARY KEY,
      $colExamId TEXT NOT NULL,
      $colTopicId TEXT NOT NULL,
      $colStatus TEXT NOT NULL DEFAULT 'not_started',
      $colNotes TEXT,
      FOREIGN KEY ($colExamId) REFERENCES exams (id) ON DELETE CASCADE,
      FOREIGN KEY ($colTopicId) REFERENCES topics (id) ON DELETE CASCADE,
      UNIQUE ($colExamId, $colTopicId)
    );
  ''';
}
