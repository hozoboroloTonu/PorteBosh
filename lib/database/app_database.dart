import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tables/courses_table.dart';
import 'tables/routine_sessions_table.dart';
import 'tables/topics_table.dart';
import 'tables/files_table.dart';
import 'tables/notes_table.dart';
import 'tables/assignments_table.dart';
import 'tables/exams_table.dart';
import 'tables/exam_topic_progress_table.dart';
import 'tables/settings_table.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  AppDatabase._internal();

  bool _initialized = false;
  final StreamController<String> _changeController = StreamController<String>.broadcast();

  Stream<String> get tableChanges => _changeController.stream;

  Future<void> initialize() async {
    if (_initialized) return;
    // In Flutter environment, Drift or sqlite3 manages the schema execution
    _initialized = true;
  }

  void notifyChange(String table) {
    if (!_changeController.isClosed) {
      _changeController.add(table);
    }
  }

  static List<String> get allTableCreationQueries => [
    CoursesTable.createTableQuery,
    RoutineSessionsTable.createTableQuery,
    RoutineSessionsTable.createIndexQuery,
    TopicsTable.createTableQuery,
    FilesTable.createTableQuery,
    NotesTable.createTableQuery,
    AssignmentsTable.createTableQuery,
    ExamsTable.createTableQuery,
    ExamTopicProgressTable.createTableQuery,
    SettingsTable.createTableQuery,
  ];

  void dispose() {
    _changeController.close();
  }
}
