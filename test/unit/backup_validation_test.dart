import 'package:flutter_test/flutter_test.dart';
import 'package:portebosh/features/backup/domain/backup_service.dart';

void main() {
  group('Backup Manifest & Payload Validation', () {
    test('validateBackupJson accepts valid payload', () {
      const validJson = '''{
        "manifest": {
          "schema_version": 1,
          "app_version": "1.0.0",
          "exported_at": "2025-01-01T12:00:00.000Z",
          "courses_count": 2,
          "files_count": 5
        },
        "data": {
          "courses": [],
          "routine_sessions": [],
          "files": [],
          "notes": [],
          "assignments": [],
          "exams": []
        }
      }''';

      final manifest = BackupService.validateBackupJson(validJson);
      expect(manifest.schemaVersion, 1);
      expect(manifest.appVersion, '1.0.0');
      expect(manifest.coursesCount, 2);
    });

    test('validateBackupJson rejects future schema versions', () {
      const futureJson = '''{
        "manifest": {
          "schema_version": 99,
          "app_version": "99.0.0",
          "exported_at": "2030-01-01T12:00:00.000Z",
          "courses_count": 0,
          "files_count": 0
        }
      }''';

      expect(() => BackupService.validateBackupJson(futureJson), throwsA(isA<FormatException>()));
    });
  });
}
