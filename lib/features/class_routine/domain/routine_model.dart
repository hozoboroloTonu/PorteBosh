import '../../../core/utils/weekday.dart';
import '../../../core/utils/time_utils.dart';

class RoutineSession {
  final String id;
  final String courseId;
  final Weekday weekday;
  final int startMinute; // 0 .. 1439
  final int endMinute;   // 0 .. 1439
  final String? titleOrType; // e.g. "Lecture", "Lab", "Tutorial"
  final String? room;
  final String? instructor;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RoutineSession({
    required this.id,
    required this.courseId,
    required this.weekday,
    required this.startMinute,
    required this.endMinute,
    this.titleOrType,
    this.room,
    this.instructor,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  String get timeFormatted => TimeUtils.formatRange(startMinute, endMinute);

  RoutineSession copyWith({
    String? id,
    String? courseId,
    Weekday? weekday,
    int? startMinute,
    int? endMinute,
    String? titleOrType,
    String? room,
    String? instructor,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoutineSession(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      weekday: weekday ?? this.weekday,
      startMinute: startMinute ?? this.startMinute,
      endMinute: endMinute ?? this.endMinute,
      titleOrType: titleOrType ?? this.titleOrType,
      room: room ?? this.room,
      instructor: instructor ?? this.instructor,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'weekday': weekday.index,
      'start_minute': startMinute,
      'end_minute': endMinute,
      'title_or_type': titleOrType,
      'room': room,
      'instructor': instructor,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory RoutineSession.fromMap(Map<String, dynamic> map) {
    return RoutineSession(
      id: map['id'] as String,
      courseId: map['course_id'] as String,
      weekday: Weekday.fromIndex(map['weekday'] as int),
      startMinute: map['start_minute'] as int,
      endMinute: map['end_minute'] as int,
      titleOrType: map['title_or_type'] as String?,
      room: map['room'] as String?,
      instructor: map['instructor'] as String?,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
