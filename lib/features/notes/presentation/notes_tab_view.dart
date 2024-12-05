import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/notes_repository.dart';
import '../domain/note_model.dart';
import '../../courses/domain/course_model.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/utils/date_utils.dart';
import '../../../app/theme/tokens.dart';

class NotesTabView extends ConsumerWidget {
  final Course course;

  const NotesTabView({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(courseNotesStreamProvider(course.id));

    return notesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (notes) {
        if (notes.isEmpty) {
          return EmptyStateView(
            icon: Icons.edit_note_outlined,
            title: 'No notes yet',
            description: 'Write quick lecture points, topic summaries, or formulas.',
            actionLabel: 'Create Note',
            onAction: () => context.push('/notes/new?courseId=${course.id}'),
          );
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('/notes/new?courseId=${course.id}'),
            child: const Icon(Icons.add),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (ctx, idx) {
              final note = notes[idx];
              return Card(
                child: ListTile(
                  title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    AcademicDateUtils.formatShortDate(note.updatedAt),
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.overdue),
                    onPressed: () async {
                      final confirmed = await showConfirmDialog(
                        context,
                        title: 'Delete Note',
                        message: 'Are you sure you want to delete "${note.title}"?',
                        isDestructive: true,
                      );
                      if (confirmed) {
                        ref.read(notesRepositoryProvider).deleteNote(note.id);
                      }
                    },
                  ),
                  onTap: () => context.push('/notes/${note.id}?courseId=${course.id}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
