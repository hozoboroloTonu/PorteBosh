import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/routine_model.dart';
import '../../../core/utils/weekday.dart';
import '../../../database/app_database.dart';

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository(ref.watch(appDatabaseProvider));
});

final courseRoutineStreamProvider = StreamProvider.family<List<RoutineSession>, String>((ref, courseId) {
  return ref.watch(routineRepositoryProvider).watchCourseSessions(courseId);
});

final allRoutineStreamProvider = StreamProvider<List<RoutineSession>>((ref) {
  return ref.watch(routineRepositoryProvider).watchAllSessions();
});

class RoutineRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();
  final List<RoutineSession> _sessions = [];
  final StreamController<List<RoutineSession>> _controller = StreamController<List<RoutineSession>>.broadcast();

  RoutineRepository(this._db);

  Stream<List<RoutineSession>> watchCourseSessions(String courseId) {
    _controller.add(List.unmodifiable(_sessions));
    return _controller.stream.map((list) {
      final filtered = list.where((s) => s.courseId == courseId).toList();
      filtered.sort((a, b) => a.startMinute.compareTo(b.startMinute));
      return filtered;
    });
  }

  Stream<List<RoutineSession>> watchAllSessions() {
    _controller.add(List.unmodifiable(_sessions));
    return _controller.stream.map((list) {
      final sorted = List<RoutineSession>.from(list);
      sorted.sort((a, b) => a.startMinute.compareTo(b.startMinute));
      return sorted;
    });
  }

  Future<List<RoutineSession>> getSessionsForWeekday(Weekday weekday) async {
    final list = _sessions.where((s) => s.weekday == weekday).toList();
    list.sort((a, b) => a.startMinute.compareTo(b.startMinute));
    return list;
  }

  Future<void> addSession({
    required String courseId,
    required Weekday weekday,
    required int startMinute,
    required int endMinute,
    String? titleOrType,
    String? room,
    String? instructor,
    String? note,
  }) async {
    final now = DateTime.now();
    final session = RoutineSession(
      id: _uuid.v4(),
      courseId: courseId,
      weekday: weekday,
      startMinute: startMinute,
      endMinute: endMinute,
      titleOrType: titleOrType?.trim().isEmpty == true ? null : titleOrType?.trim(),
      room: room?.trim().isEmpty == true ? null : room?.trim(),
      instructor: instructor?.trim().isEmpty == true ? null : instructor?.trim(),
      note: note?.trim().isEmpty == true ? null : note?.trim(),
      createdAt: now,
      updatedAt: now,
    );
    _sessions.add(session);
    _db.notifyChange('weekly_class_sessions');
    _controller.add(List.unmodifiable(_sessions));
  }

  Future<void> updateSession(RoutineSession session) async {
    final idx = _sessions.indexWhere((s) => s.id == session.id);
    if (idx != -1) {
      _sessions[idx] = session.copyWith(updatedAt: DateTime.now());
      _db.notifyChange('weekly_class_sessions');
      _controller.add(List.unmodifiable(_sessions));
    }
  }

  Future<void> deleteSession(String sessionId) async {
    _sessions.removeWhere((s) => s.id == sessionId);
    _db.notifyChange('weekly_class_sessions');
    _controller.add(List.unmodifiable(_sessions));
  }
}
