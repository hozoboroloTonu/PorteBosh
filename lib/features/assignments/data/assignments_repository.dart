import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/assignment_model.dart';
import '../../../database/app_database.dart';

final assignmentsRepositoryProvider = Provider<AssignmentsRepository>((ref) {
  return AssignmentsRepository(ref.watch(appDatabaseProvider));
});

final allAssignmentsStreamProvider = StreamProvider<List<Assignment>>((ref) {
  return ref.watch(assignmentsRepositoryProvider).watchAllAssignments();
});

class AssignmentsRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();
  final List<Assignment> _assignments = [];
  final StreamController<List<Assignment>> _controller = StreamController<List<Assignment>>.broadcast();

  AssignmentsRepository(this._db);

  Stream<List<Assignment>> watchAllAssignments() {
    _controller.add(List.unmodifiable(_assignments));
    return _controller.stream.map((list) {
      final sorted = List<Assignment>.from(list);
      sorted.sort((a, b) {
        if (a.deadlineAt == null) return 1;
        if (b.deadlineAt == null) return -1;
        return a.deadlineAt!.compareTo(b.deadlineAt!);
      });
      return sorted;
    });
  }

  Future<void> addAssignment({
    required String courseId,
    required String title,
    String? description,
    DateTime? deadlineAt,
    AssignmentPriority priority = AssignmentPriority.medium,
  }) async {
    final now = DateTime.now();
    _assignments.add(Assignment(
      id: _uuid.v4(),
      courseId: courseId,
      title: title,
      description: description,
      deadlineAt: deadlineAt,
      priority: priority,
      createdAt: now,
      updatedAt: now,
    ));
    _db.notifyChange('assignments');
    _controller.add(List.unmodifiable(_assignments));
  }

  Future<void> updateStatus(String id, AssignmentStatus status) async {
    final idx = _assignments.indexWhere((a) => a.id == id);
    if (idx != -1) {
      _assignments[idx] = _assignments[idx].copyWith(status: status, updatedAt: DateTime.now());
      _db.notifyChange('assignments');
      _controller.add(List.unmodifiable(_assignments));
    }
  }

  Future<void> deleteAssignment(String id) async {
    _assignments.removeWhere((a) => a.id == id);
    _db.notifyChange('assignments');
    _controller.add(List.unmodifiable(_assignments));
  }
}
