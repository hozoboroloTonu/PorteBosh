import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../courses/data/courses_repository.dart';
import '../../courses/presentation/course_edit_dialog.dart';
import '../../class_routine/data/routine_repository.dart';
import '../../assignments/data/assignments_repository.dart';
import '../../exams/data/exams_repository.dart';
import '../../course_files/data/file_repository.dart';
import '../../../core/utils/weekday.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../app/theme/tokens.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final todayWeekday = Weekday.fromDateTime(now);

    final courses = ref.watch(coursesStreamProvider).asData?.value ?? [];
    final routines = ref.watch(allRoutineStreamProvider).asData?.value ?? [];
    final tasks = ref.watch(allAssignmentsStreamProvider).asData?.value ?? [];
    final exams = ref.watch(allExamsStreamProvider).asData?.value ?? [];

    final todayRoutines = routines.where((r) => r.weekday == todayWeekday).toList();
    final pendingTasks = tasks.where((t) => !t.isCompleted).take(3).toList();
    final upcomingExams = exams.where((e) => e.startsAt.isAfter(now)).take(2).toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'PorteBosh',
        subtitle: '${todayWeekday.fullName}, ${AcademicDateUtils.formatDate(now)}',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _SectionHeader(title: "Today's Classes", actionLabel: 'View Schedule', onAction: () => context.go('/calendar')),
          const SizedBox(height: AppSpacing.xs),
          if (todayRoutines.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text('No classes today! Enjoy your self-study time.', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...todayRoutines.map((r) {
              final course = courses.firstWhere((c) => c.id == r.courseId, orElse: () => courses.first);
              return Card(
                child: ListTile(
                  leading: Container(width: 4, height: 36, color: course.color),
                  title: Text(course.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${r.timeFormatted} • ${r.room ?? "Room TBD"}'),
                  onTap: () => context.push('/courses/${course.id}'),
                ),
              );
            }),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeader(title: 'Active Tasks', actionLabel: 'All Tasks', onAction: () => context.go('/tasks')),
          const SizedBox(height: AppSpacing.xs),
          if (pendingTasks.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text('All caught up! No pending assignments.', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...pendingTasks.map((t) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.task_alt, color: AppColors.accentLight),
                    title: Text(t.title),
                    subtitle: Text(t.deadlineAt != null ? 'Due: ${AcademicDateUtils.relativeDateLabel(t.deadlineAt!)}' : 'No deadline'),
                  ),
                )),
          const SizedBox(height: AppSpacing.lg),
          const _QuickActionsCard(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({Key? key, required this.title, this.actionLabel, this.onAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!, style: const TextStyle(fontSize: 13)),
          ),
      ],
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionBtn(icon: Icons.add_circle_outline, label: 'Add Course', onTap: () => showCourseEditDialog(context)),
                _ActionBtn(icon: Icons.calendar_month_outlined, label: 'Routine', onTap: () => context.go('/calendar')),
                _ActionBtn(icon: Icons.check_circle_outline, label: 'Add Task', onTap: () => context.go('/tasks')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionBtn({Key? key, required this.icon, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
