class SettingsTable {
  static const String tableName = 'app_settings';

  static const String colKey = 'key';
  static const String colValue = 'value';

  static const String createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $colKey TEXT PRIMARY KEY,
      $colValue TEXT NOT NULL
    );
  ''';
}
