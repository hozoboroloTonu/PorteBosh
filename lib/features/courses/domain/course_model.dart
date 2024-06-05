import 'package:flutter/material.dart';

class Course {
  final String id;
  final String? code;
  final String name;
  final String? instructor;
  final String? semester;
  final double? credits;
  final Color color;
  final String? description;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Course({
    required this.id,
    this.code,
    required this.name,
    this.instructor,
    this.semester,
    this.credits,
    required this.color,
    this.description,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Course copyWith({
    String? id,
    String? code,
    String? name,
    String? instructor,
    String? semester,
    double? credits,
    Color? color,
    String? description,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      instructor: instructor ?? this.instructor,
      semester: semester ?? this.semester,
      credits: credits ?? this.credits,
      color: color ?? this.color,
      description: description ?? this.description,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'instructor': instructor,
      'semester': semester,
      'credits': credits,
      'color_value': color.value,
      'description': description,
      'is_archived': isArchived ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as String,
      code: map['code'] as String?,
      name: map['name'] as String,
      instructor: map['instructor'] as String?,
      semester: map['semester'] as String?,
      credits: (map['credits'] as num?)?.toDouble(),
      color: Color(map['color_value'] as int),
      description: map['description'] as String?,
      isArchived: (map['is_archived'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
