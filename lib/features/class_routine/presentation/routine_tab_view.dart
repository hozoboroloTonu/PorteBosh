import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/routine_repository.dart';
import '../domain/routine_model.dart';
import '../../courses/domain/course_model.dart';
import 'widgets/weekday_selector.dart';
import 'session_edit_dialog.dart';
import '../../../../core/utils/weekday.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../app/theme/tokens.dart';

class RoutineTabView extends ConsumerStatefulWidget {
  final Course course;

  const RoutineTabView({Key? key, required this.course}) : super(key: key);

  @override
  ConsumerState<RoutineTabView> createState() => _RoutineTabViewState();
}

class _RoutineTabViewState extends ConsumerState<RoutineTabView> {
  Weekday _selectedDay = Weekday.sat;

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(courseRoutineStreamProvider(widget.course.id));

    return sessionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (sessions) {
        final activeDays = sessions.map((s) => s.weekday).toSet();
        final daySessions = sessions.where((s) => s.weekday == _selectedDay).toList();
        daySessions.sort((a, b) => a.startMinute.compareTo(b.startMinute));

        return Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            WeekdaySelector(
              selectedDay: _selectedDay,
              activeDays: activeDays,
              courseAccentColor: widget.course.color,
              onDaySelected: (day) => setState(() => _selectedDay = day),
            ),
            const Divider(height: AppSpacing.lg),
            Expanded(
              child: daySessions.isEmpty
                  ? EmptyStateView(
                      icon: Icons.event_busy_outlined,
                      title: 'No class on ${_selectedDay.fullName}',
                      description: 'There are no weekly class sessions scheduled for this day.',
                      actionLabel: 'Schedule Session',
                      onAction: () => showSessionEditDialog(
                        context,
                        courseId: widget.course.id,
                        defaultWeekday: _selectedDay,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      itemCount: daySessions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (ctx, idx) {
                        final session = daySessions[idx];
                        return _SessionCard(
                          session: session,
                          course: widget.course,
                          onEdit: () => showSessionEditDialog(
                            context,
                            courseId: widget.course.id,
                            defaultWeekday: _selectedDay,
                            sessionToEdit: session,
                          ),
                          onDelete: () => _confirmDelete(session),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(RoutineSession session) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete Class Session',
      message: 'Are you sure you want to remove this ${session.titleOrType ?? "class"} session?',
      isDestructive: true,
    );
    if (confirmed) {
      ref.read(routineRepositoryProvider).deleteSession(session.id);
    }
  }
}

class _SessionCard extends StatelessWidget {
  final RoutineSession session;
  final Course course;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SessionCard({
    Key? key,
    required this.session,
    required this.course,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: course.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadii.sm),
              ),
              child: Text(
                session.timeFormatted,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: course.color,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.titleOrType ?? 'Class Session',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  if (session.room != null && session.room!.isNotEmpty)
                    Text(
                      'Room: ${session.room}',
                      style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.overdue),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
