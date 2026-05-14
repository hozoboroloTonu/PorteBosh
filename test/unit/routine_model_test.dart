import 'package:flutter_test/flutter_test.dart';
import 'package:portebosh/features/class_routine/domain/routine_model.dart';
import 'package:portebosh/core/utils/weekday.dart';

void main() {
  group('Routine Session Ordering and Conventions', () {
    test('Saturday-first order begins with Saturday', () {
      expect(Weekday.saturdayFirst.first, Weekday.sat);
      expect(Weekday.saturdayFirst.last, Weekday.fri);
    });

    test('RoutineSession formatted time range matches calculations', () {
      final session = RoutineSession(
        id: 's-1',
        courseId: 'c-1',
        weekday: Weekday.sun,
        startMinute: 600, // 10:00 AM
        endMinute: 690,   // 11:30 AM
        titleOrType: 'Lecture',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(session.timeFormatted, '10:00 AM – 11:30 AM');
    });
  });
}
