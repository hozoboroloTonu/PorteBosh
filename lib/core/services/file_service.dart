import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FileService {
  static const _uuid = Uuid();

  /// Gets or creates the app-managed documents directory for stored academic files
  static Future<Directory> getManagedStorageDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final managedDir = Directory(p.join(docsDir.path, 'portebosh_files'));
    if (!await managedDir.exists()) {
      await managedDir.create(recursive: true);
    }
    return managedDir;
  }

  /// Copies an imported source file safely into app-managed storage with a collision-resistant filename
  static Future<String> importLocalFile({
    required File sourceFile,
    required String originalFilename,
  }) async {
    final managedDir = await getManagedStorageDirectory();
    final extension = p.extension(originalFilename);
    final uniqueName = '${_uuid.v4()}$extension';
    final targetPath = p.join(managedDir.path, uniqueName);

    // Stream copy to handle large files smoothly
    await sourceFile.copy(targetPath);

    // Return the relative path stored in database
    return uniqueName;
  }

  /// Resolves the absolute path for an app-managed relative path
  static Future<String> getAbsolutePath(String relativePath) async {
    final managedDir = await getManagedStorageDirectory();
    return p.join(managedDir.path, relativePath);
  }

  /// Permanently deletes file bytes from disk
  static Future<void> deleteManagedFile(String relativePath) async {
    final absPath = await getAbsolutePath(relativePath);
    final file = File(absPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Formats byte count to readable string e.g. "4.2 MB"
  static String formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double d = bytes.toDouble();
    while (d >= 1024 && i < suffixes.length - 1) {
      d /= 1024;
      i++;
    }
    return '${d.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }
}
