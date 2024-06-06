import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/course_model.dart';
import '../../../database/app_database.dart';

final coursesRepositoryProvider = Provider<CoursesRepository>((ref) {
  return CoursesRepository(ref.watch(appDatabaseProvider));
});

final coursesStreamProvider = StreamProvider<List<Course>>((ref) {
  return ref.watch(coursesRepositoryProvider).watchCourses();
});

class CoursesRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();
  final List<Course> _cachedCourses = [];
  final StreamController<List<Course>> _controller = StreamController<List<Course>>.broadcast();

  CoursesRepository(this._db);

  Stream<List<Course>> watchCourses({bool includeArchived = false}) {
    // Deliver initial cached state immediately
    _controller.add(_filtered(includeArchived));
    return _controller.stream;
  }

  List<Course> _filtered(bool includeArchived) {
    if (includeArchived) return List.unmodifiable(_cachedCourses);
    return List.unmodifiable(_cachedCourses.where((c) => !c.isArchived));
  }

  Future<List<Course>> getAllCourses({bool includeArchived = false}) async {
    return _filtered(includeArchived);
  }

  Future<Course?> getCourseById(String id) async {
    final idx = _cachedCourses.indexWhere((c) => c.id == id);
    if (idx != -1) return _cachedCourses[idx];
    return null;
  }

  Future<void> createCourse({
    String? code,
    required String name,
    String? instructor,
    String? semester,
    double? credits,
    required Color color,
    String? description,
  }) async {
    final now = DateTime.now();
    final course = Course(
      id: _uuid.v4(),
      code: code?.trim().isEmpty == true ? null : code?.trim(),
      name: name.trim(),
      instructor: instructor?.trim().isEmpty == true ? null : instructor?.trim(),
      semester: semester?.trim().isEmpty == true ? null : semester?.trim(),
      credits: credits,
      color: color,
      description: description?.trim().isEmpty == true ? null : description?.trim(),
      createdAt: now,
      updatedAt: now,
    );
    _cachedCourses.add(course);
    _db.notifyChange('courses');
    _controller.add(_filtered(true));
  }

  Future<void> updateCourse(Course course) async {
    final idx = _cachedCourses.indexWhere((c) => c.id == course.id);
    if (idx != -1) {
      _cachedCourses[idx] = course.copyWith(updatedAt: DateTime.now());
      _db.notifyChange('courses');
      _controller.add(_filtered(true));
    }
  }

  Future<void> toggleArchive(String courseId) async {
    final idx = _cachedCourses.indexWhere((c) => c.id == courseId);
    if (idx != -1) {
      final existing = _cachedCourses[idx];
      _cachedCourses[idx] = existing.copyWith(
        isArchived: !existing.isArchived,
        updatedAt: DateTime.now(),
      );
      _db.notifyChange('courses');
      _controller.add(_filtered(true));
    }
  }

  Future<void> deleteCourse(String courseId) async {
    _cachedCourses.removeWhere((c) => c.id == courseId);
    _db.notifyChange('courses');
    _controller.add(_filtered(true));
  }
}
