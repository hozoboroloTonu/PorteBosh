import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/file_model.dart';
import '../../../database/app_database.dart';
import '../../../core/services/file_service.dart';

final fileRepositoryProvider = Provider<FileRepository>((ref) {
  return FileRepository(ref.watch(appDatabaseProvider));
});

final courseFilesStreamProvider = StreamProvider.family<List<CourseFile>, String>((ref, courseId) {
  return ref.watch(fileRepositoryProvider).watchCourseFiles(courseId);
});

final recentFilesStreamProvider = StreamProvider<List<CourseFile>>((ref) {
  return ref.watch(fileRepositoryProvider).watchRecentFiles();
});

class FileRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();
  final List<CourseFile> _files = [];
  final StreamController<List<CourseFile>> _controller = StreamController<List<CourseFile>>.broadcast();

  FileRepository(this._db);

  Stream<List<CourseFile>> watchCourseFiles(String courseId) {
    _controller.add(List.unmodifiable(_files));
    return _controller.stream.map((list) {
      return list.where((f) => f.courseId == courseId).toList();
    });
  }

  Stream<List<CourseFile>> watchRecentFiles() {
    _controller.add(List.unmodifiable(_files));
    return _controller.stream.map((list) {
      final sorted = List<CourseFile>.from(list);
      sorted.sort((a, b) => b.importedAt.compareTo(a.importedAt));
      return sorted.take(10).toList();
    });
  }

  Future<void> addFileRecord({
    required String originalName,
    required String storedRelativePath,
    required String mimeType,
    required String extension,
    required int sizeBytes,
    required String courseId,
    String? topicId,
    String? description,
  }) async {
    final now = DateTime.now();
    final file = CourseFile(
      id: _uuid.v4(),
      originalName: originalName,
      storedRelativePath: storedRelativePath,
      mimeType: mimeType,
      extension: extension,
      sizeBytes: sizeBytes,
      courseId: courseId,
      topicId: topicId,
      importedAt: now,
      description: description,
    );
    _files.add(file);
    _db.notifyChange('files');
    _controller.add(List.unmodifiable(_files));
  }

  Future<void> deleteFile(String fileId) async {
    final idx = _files.indexWhere((f) => f.id == fileId);
    if (idx != -1) {
      final file = _files[idx];
      await FileService.deleteManagedFile(file.storedRelativePath);
      _files.removeAt(idx);
      _db.notifyChange('files');
      _controller.add(List.unmodifiable(_files));
    }
  }
}
