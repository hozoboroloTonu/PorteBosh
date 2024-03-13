import 'package:flutter/material.dart';

class TimeUtils {
  /// Converts TimeOfDay to minute of day (0 .. 1439)
  static int toMinuteOfDay(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  /// Converts minute of day (0 .. 1439) to TimeOfDay
  static TimeOfDay fromMinuteOfDay(int minutes) {
    final clamped = minutes.clamp(0, 1439);
    return TimeOfDay(hour: clamped ~/ 60, minute: clamped % 60);
  }

  /// Formats minute of day to readable 12-hour or 24-hour string
  static String formatMinutes(int minutes, {bool is24Hour = false}) {
    final time = fromMinuteOfDay(minutes);
    if (is24Hour) {
      final h = time.hour.toString().padLeft(2, '0');
      final m = time.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } else {
      final hour12 = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final m = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour12:$m $period';
    }
  }

  /// Formats time range e.g. "10:00 AM – 11:30 AM"
  static String formatRange(int startMinutes, int endMinutes, {bool is24Hour = false}) {
    return '${formatMinutes(startMinutes, is24Hour: is24Hour)} – ${formatMinutes(endMinutes, is24Hour: is24Hour)}';
  }

  /// Validates whether start and end minutes form a valid non-empty duration on same day
  static bool isValidRange(int startMinutes, int endMinutes) {
    return startMinutes >= 0 && endMinutes > startMinutes && endMinutes <= 1439;
  }

  /// Detects whether two time ranges overlap
  static bool hasOverlap(int startA, int endA, int startB, int endB) {
    return startA < endB && startB < endA;
  }
}
