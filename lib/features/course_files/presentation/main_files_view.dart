import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/file_repository.dart';
import '../domain/file_model.dart';
import '../../courses/domain/course_model.dart';
import '../../../core/services/file_service.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../app/theme/tokens.dart';

class MainFilesView extends ConsumerWidget {
  final Course course;

  const MainFilesView({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesAsync = ref.watch(courseFilesStreamProvider(course.id));

    return filesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (files) {
        if (files.isEmpty) {
          return EmptyStateView(
            icon: Icons.folder_open_outlined,
            title: 'No documents yet',
            description: 'Import lecture slides, course outlines, syllabus, or lab manuals.',
            actionLabel: 'Import File',
            onAction: () => _importDocument(context, ref),
          );
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _importDocument(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Import File'),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: files.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (ctx, idx) {
              final file = files[idx];
              return _FileCard(file: file, course: course);
            },
          ),
        );
      },
    );
  }

  void _importDocument(BuildContext context, WidgetRef ref) async {
    // Android file picker invocation
  }
}

class _FileCard extends ConsumerWidget {
  final CourseFile file;
  final Course course;

  const _FileCard({Key? key, required this.file, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(
          file.isPdf ? Icons.picture_as_pdf : (file.isImage ? Icons.image : Icons.insert_drive_file_outlined),
          color: file.isPdf ? AppColors.overdue : course.color,
          size: 32,
        ),
        title: Text(
          file.originalName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          FileService.formatBytes(file.sizeBytes),
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6)),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.overdue),
          onPressed: () async {
            final confirm = await showConfirmDialog(
              context,
              title: 'Delete Document',
              message: 'Are you sure you want to permanently delete "${file.originalName}"?',
              isDestructive: true,
            );
            if (confirm) {
              ref.read(fileRepositoryProvider).deleteFile(file.id);
            }
          },
        ),
        onTap: () {
          if (file.isPdf) {
            context.push('/pdf-viewer?path=${Uri.encodeComponent(file.storedRelativePath)}&title=${Uri.encodeComponent(file.originalName)}');
          } else if (file.isImage) {
            context.push('/image-viewer?path=${Uri.encodeComponent(file.storedRelativePath)}&title=${Uri.encodeComponent(file.originalName)}');
          }
        },
      ),
    );
  }
}
