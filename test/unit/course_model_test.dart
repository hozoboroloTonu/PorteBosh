import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portebosh/features/courses/domain/course_model.dart';

void main() {
  group('Course Model Serialization', () {
    test('toMap and fromMap retain full integrity', () {
      final now = DateTime(2024, 6, 1, 10, 0);
      final course = Course(
        id: 'course-1',
        code: 'CSE-101',
        name: 'Computer Science Fundamentals',
        instructor: 'Dr. Alan Turing',
        semester: 'Spring 2024',
        credits: 3.0,
        color: const Color(0xFF176B5B),
        description: 'Core introductory module',
        isArchived: false,
        createdAt: now,
        updatedAt: now,
      );

      final map = course.toMap();
      final revived = Course.fromMap(map);

      expect(revived.id, course.id);
      expect(revived.name, course.name);
      expect(revived.code, course.code);
      expect(revived.color.value, course.color.value);
      expect(revived.isArchived, isFalse);
    });
  });
}
