import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/exam_model.dart';
import '../../../database/app_database.dart';

final examsRepositoryProvider = Provider<ExamsRepository>((ref) {
  return ExamsRepository(ref.watch(appDatabaseProvider));
});

final allExamsStreamProvider = StreamProvider<List<Exam>>((ref) {
  return ref.watch(examsRepositoryProvider).watchAllExams();
});

class ExamsRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();
  final List<Exam> _exams = [];
  final StreamController<List<Exam>> _controller = StreamController<List<Exam>>.broadcast();

  ExamsRepository(this._db);

  Stream<List<Exam>> watchAllExams() {
    _controller.add(List.unmodifiable(_exams));
    return _controller.stream.map((list) {
      final sorted = List<Exam>.from(list);
      sorted.sort((a, b) => a.startsAt.compareTo(b.startsAt));
      return sorted;
    });
  }

  Future<void> addExam({
    required String courseId,
    required String title,
    required DateTime startsAt,
    double? totalMarks,
    double? acquiredMarks,
    String? notes,
  }) async {
    final now = DateTime.now();
    _exams.add(Exam(
      id: _uuid.v4(),
      courseId: courseId,
      title: title,
      startsAt: startsAt,
      totalMarks: totalMarks,
      acquiredMarks: acquiredMarks,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    ));
    _db.notifyChange('exams');
    _controller.add(List.unmodifiable(_exams));
  }

  Future<void> deleteExam(String id) async {
    _exams.removeWhere((e) => e.id == id);
    _db.notifyChange('exams');
    _controller.add(List.unmodifiable(_exams));
  }
}
