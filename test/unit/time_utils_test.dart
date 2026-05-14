import 'package:flutter_test/flutter_test.dart';
import 'package:portebosh/core/utils/time_utils.dart';

void main() {
  group('TimeUtils Unit Tests', () {
    test('formatMinutes formats 12-hour properly', () {
      expect(TimeUtils.formatMinutes(0), '12:00 AM');
      expect(TimeUtils.formatMinutes(540), '9:00 AM');
      expect(TimeUtils.formatMinutes(720), '12:00 PM');
      expect(TimeUtils.formatMinutes(810), '1:30 PM');
      expect(TimeUtils.formatMinutes(1439), '11:59 PM');
    });

    test('formatMinutes formats 24-hour properly', () {
      expect(TimeUtils.formatMinutes(540, is24Hour: true), '09:00');
      expect(TimeUtils.formatMinutes(810, is24Hour: true), '13:30');
    });

    test('isValidRange rejects start >= end', () {
      expect(TimeUtils.isValidRange(600, 500), isFalse);
      expect(TimeUtils.isValidRange(600, 600), isFalse);
      expect(TimeUtils.isValidRange(600, 700), isTrue);
    });

    test('hasOverlap detects session overlaps accurately', () {
      // 09:00 - 10:30 and 10:00 - 11:00 (Overlap)
      expect(TimeUtils.hasOverlap(540, 630, 600, 660), isTrue);
      // 09:00 - 10:00 and 10:00 - 11:00 (No Overlap - contiguous)
      expect(TimeUtils.hasOverlap(540, 600, 600, 660), isFalse);
      // 09:00 - 10:00 and 11:00 - 12:00 (Disjoint)
      expect(TimeUtils.hasOverlap(540, 600, 660, 720), isFalse);
    });
  });
}
