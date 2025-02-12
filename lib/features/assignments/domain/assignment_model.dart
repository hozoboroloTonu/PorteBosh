enum AssignmentStatus {
  pending,
  inProgress,
  ready,
  submitted,
  completed;

  String get label {
    switch (this) {
      case AssignmentStatus.pending: return 'Pending';
      case AssignmentStatus.inProgress: return 'In Progress';
      case AssignmentStatus.ready: return 'Ready';
      case AssignmentStatus.submitted: return 'Submitted';
      case AssignmentStatus.completed: return 'Completed';
    }
  }
}

enum AssignmentPriority {
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case AssignmentPriority.low: return 'Low';
      case AssignmentPriority.medium: return 'Medium';
      case AssignmentPriority.high: return 'High';
    }
  }
}

class Assignment {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final DateTime? deadlineAt;
  final AssignmentPriority priority;
  final AssignmentStatus status;
  final int? estimatedMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Assignment({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    this.deadlineAt,
    this.priority = AssignmentPriority.medium,
    this.status = AssignmentStatus.pending,
    this.estimatedMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isCompleted => status == AssignmentStatus.completed;

  Assignment copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    DateTime? deadlineAt,
    AssignmentPriority? priority,
    AssignmentStatus? status,
    int? estimatedMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Assignment(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      deadlineAt: deadlineAt ?? this.deadlineAt,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'deadline_at': deadlineAt?.toIso8601String(),
      'priority': priority.name,
      'status': status.name,
      'estimated_minutes': estimatedMinutes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'] as String,
      courseId: map['course_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      deadlineAt: map['deadline_at'] != null ? DateTime.parse(map['deadline_at'] as String) : null,
      priority: AssignmentPriority.values.firstWhere((p) => p.name == map['priority'], orElse: () => AssignmentPriority.medium),
      status: AssignmentStatus.values.firstWhere((s) => s.name == map['status'], orElse: () => AssignmentStatus.pending),
      estimatedMinutes: map['estimated_minutes'] as int?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
