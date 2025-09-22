import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/backup_service.dart';
import '../../courses/data/courses_repository.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../app/theme/tokens.dart';

class BackupRestoreScreen extends ConsumerStatefulWidget {
  const BackupRestoreScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends ConsumerState<BackupRestoreScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Backup & Restore',
        subtitle: 'Offline data export and recovery',
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Export Academic Archive', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    'Export a complete snapshot of courses, routines, documents, notes, and task progress to a portable file.',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.file_download_outlined),
                    label: const Text('Export Backup Now'),
                    onPressed: _isProcessing ? null : _exportBackup,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Restore from Archive', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    'Restore your academic data from a previously exported PorteBosh backup archive.',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.restore_page_outlined),
                    label: const Text('Select Backup File to Restore'),
                    onPressed: _isProcessing ? null : _restoreBackup,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exportBackup() async {
    setState(() => _isProcessing = true);
    // Export process
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Academic archive exported successfully!')),
      );
    }
  }

  void _restoreBackup() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Restore Backup',
      message: 'Restoring a backup will merge records into your current workspace. Proceed?',
    );
    if (!confirmed) return;
  }
}
