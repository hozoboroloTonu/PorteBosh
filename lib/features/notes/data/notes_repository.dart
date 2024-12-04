import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/note_model.dart';
import '../../../database/app_database.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository(ref.watch(appDatabaseProvider));
});

final courseNotesStreamProvider = StreamProvider.family<List<Note>, String>((ref, courseId) {
  return ref.watch(notesRepositoryProvider).watchCourseNotes(courseId);
});

class NotesRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();
  final List<Note> _notes = [];
  final StreamController<List<Note>> _controller = StreamController<List<Note>>.broadcast();

  NotesRepository(this._db);

  Stream<List<Note>> watchCourseNotes(String courseId) {
    _controller.add(List.unmodifiable(_notes));
    return _controller.stream.map((list) {
      return list.where((n) => n.courseId == courseId).toList();
    });
  }

  Future<void> saveNote({
    String? id,
    required String courseId,
    String? topicId,
    required String title,
    required String body,
  }) async {
    final now = DateTime.now();
    if (id != null) {
      final idx = _notes.indexWhere((n) => n.id == id);
      if (idx != -1) {
        _notes[idx] = _notes[idx].copyWith(title: title, body: body, updatedAt: now);
      }
    } else {
      _notes.add(Note(
        id: _uuid.v4(),
        courseId: courseId,
        topicId: topicId,
        title: title,
        body: body,
        createdAt: now,
        updatedAt: now,
      ));
    }
    _db.notifyChange('notes');
    _controller.add(List.unmodifiable(_notes));
  }

  Future<void> deleteNote(String noteId) async {
    _notes.removeWhere((n) => n.id == noteId);
    _db.notifyChange('notes');
    _controller.add(List.unmodifiable(_notes));
  }
}
