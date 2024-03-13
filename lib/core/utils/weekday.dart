enum Weekday {
  sat,
  sun,
  mon,
  tue,
  wed,
  thu,
  fri;

  /// Ordered Saturday-first convention for academic routine
  static const List<Weekday> saturdayFirst = [
    Weekday.sat,
    Weekday.sun,
    Weekday.mon,
    Weekday.tue,
    Weekday.wed,
    Weekday.thu,
    Weekday.fri,
  ];

  String get shortLabel {
    switch (this) {
      case Weekday.sat: return 'SAT';
      case Weekday.sun: return 'SUN';
      case Weekday.mon: return 'MON';
      case Weekday.tue: return 'TUE';
      case Weekday.wed: return 'WED';
      case Weekday.thu: return 'THU';
      case Weekday.fri: return 'FRI';
    }
  }

  String get fullName {
    switch (this) {
      case Weekday.sat: return 'Saturday';
      case Weekday.sun: return 'Sunday';
      case Weekday.mon: return 'Monday';
      case Weekday.tue: return 'Tuesday';
      case Weekday.wed: return 'Wednesday';
      case Weekday.thu: return 'Thursday';
      case Weekday.fri: return 'Friday';
    }
  }

  /// Maps standard DateTime weekday (Mon=1 ... Sun=7) to our Weekday enum
  static Weekday fromDateTime(DateTime dt) {
    switch (dt.weekday) {
      case DateTime.saturday: return Weekday.sat;
      case DateTime.sunday: return Weekday.sun;
      case DateTime.monday: return Weekday.mon;
      case DateTime.tuesday: return Weekday.tue;
      case DateTime.wednesday: return Weekday.wed;
      case DateTime.thursday: return Weekday.thu;
      case DateTime.friday: return Weekday.fri;
      default: return Weekday.sat;
    }
  }

  static Weekday fromIndex(int index) {
    if (index < 0 || index >= Weekday.values.length) {
      return Weekday.sat;
    }
    return Weekday.values[index];
  }
}
