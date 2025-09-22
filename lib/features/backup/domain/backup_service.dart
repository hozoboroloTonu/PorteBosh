import 'dart:convert';
import 'dart:io';
import '../../../core/services/file_service.dart';

class BackupManifest {
  final int schemaVersion;
  final String appVersion;
  final DateTime exportedAt;
  final int coursesCount;
  final int filesCount;

  const BackupManifest({
    required this.schemaVersion,
    required this.appVersion,
    required this.exportedAt,
    required this.coursesCount,
    required this.filesCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'schema_version': schemaVersion,
      'app_version': appVersion,
      'exported_at': exportedAt.toIso8601String(),
      'courses_count': coursesCount,
      'files_count': filesCount,
    };
  }

  factory BackupManifest.fromMap(Map<String, dynamic> map) {
    return BackupManifest(
      schemaVersion: map['schema_version'] as int,
      appVersion: map['app_version'] as String,
      exportedAt: DateTime.parse(map['exported_at'] as String),
      coursesCount: map['courses_count'] as int,
      filesCount: map['files_count'] as int,
    );
  }
}

class BackupService {
  static const int currentSchemaVersion = 1;
  static const String appVersion = '1.0.0';

  /// Generates full offline backup JSON payload
  static Future<String> generateBackupJson({
    required List<Map<String, dynamic>> courses,
    required List<Map<String, dynamic>> routines,
    required List<Map<String, dynamic>> files,
    required List<Map<String, dynamic>> notes,
    required List<Map<String, dynamic>> assignments,
    required List<Map<String, dynamic>> exams,
  }) async {
    final manifest = BackupManifest(
      schemaVersion: currentSchemaVersion,
      appVersion: appVersion,
      exportedAt: DateTime.now(),
      coursesCount: courses.length,
      filesCount: files.length,
    );

    final payload = {
      'manifest': manifest.toMap(),
      'data': {
        'courses': courses,
        'routine_sessions': routines,
        'files': files,
        'notes': notes,
        'assignments': assignments,
        'exams': exams,
      },
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// Validates an incoming backup payload before executing restore
  static BackupManifest validateBackupJson(String jsonString) {
    final dynamic decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid backup archive structure');
    }

    final manifestMap = decoded['manifest'];
    if (manifestMap is! Map<String, dynamic>) {
      throw const FormatException('Missing backup manifest');
    }

    final manifest = BackupManifest.fromMap(manifestMap);
    if (manifest.schemaVersion > currentSchemaVersion) {
      throw FormatException('Unsupported backup schema version: ${manifest.schemaVersion}');
    }

    return manifest;
  }
}
