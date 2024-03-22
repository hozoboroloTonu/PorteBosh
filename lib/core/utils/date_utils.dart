import 'package:intl/intl.dart';

class AcademicDateUtils {
  static final DateFormat _monthDayYear = DateFormat('MMM d, yyyy');
  static final DateFormat _shortDate = DateFormat('EEE, MMM d');

  static String formatDate(DateTime date) {
    return _monthDayYear.format(date);
  }

  static String formatShortDate(DateTime date) {
    return _shortDate.format(date);
  }

  /// Returns contextual label e.g. "Today", "Tomorrow", "Yesterday", or formatted date
  static String relativeDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final diff = target.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return formatDate(date);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isOverdue(DateTime deadline) {
    return deadline.isBefore(DateTime.now());
  }
}
