import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/assignments_repository.dart';
import '../domain/assignment_model.dart';
import 'assignment_edit_dialog.dart';
import '../../courses/data/courses_repository.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/utils/date_utils.dart';
import '../../../app/theme/tokens.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  bool _hideCompleted = false;

  @override
  Widget build(BuildContext context) {
    final assignmentsAsync = ref.watch(allAssignmentsStreamProvider);
    final coursesAsync = ref.watch(coursesStreamProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Academic Tasks',
        subtitle: 'Assignments and homework deadlines',
        actions: [
          IconButton(
            icon: Icon(_hideCompleted ? Icons.visibility_off : Icons.visibility),
            tooltip: _hideCompleted ? 'Show completed' : 'Hide completed',
            onPressed: () => setState(() => _hideCompleted = !_hideCompleted),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAssignmentEditDialog(context),
        child: const Icon(Icons.add),
      ),
      body: assignmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tasks) {
          final courses = coursesAsync.asData?.value ?? [];
          final filtered = tasks.where((t) => !_hideCompleted || !t.isCompleted).toList();

          if (filtered.isEmpty) {
            return EmptyStateView(
              icon: Icons.checklist_rtl_outlined,
              title: 'No pending tasks',
              description: 'Stay on top of coursework by adding assignments and project deliverables.',
              actionLabel: 'Add Assignment',
              onAction: () => showAssignmentEditDialog(context),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (ctx, idx) {
              final task = filtered[idx];
              final course = courses.firstWhere((c) => c.id == task.courseId, orElse: () => courses.first);
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (val) {
                      ref.read(assignmentsRepositoryProvider).updateStatus(
                        task.id,
                        val == true ? AssignmentStatus.completed : AssignmentStatus.pending,
                      );
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(
                    task.deadlineAt != null ? 'Due: ${AcademicDateUtils.relativeDateLabel(task.deadlineAt!)}' : 'No deadline',
                    style: TextStyle(
                      fontSize: 12,
                      color: task.deadlineAt != null && AcademicDateUtils.isOverdue(task.deadlineAt!) && !task.isCompleted
                          ? AppColors.overdue
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.overdue),
                    onPressed: () async {
                      final confirmed = await showConfirmDialog(
                        context,
                        title: 'Delete Assignment',
                        message: 'Remove "${task.title}"?',
                        isDestructive: true,
                      );
                      if (confirmed) {
                        ref.read(assignmentsRepositoryProvider).deleteAssignment(task.id);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
