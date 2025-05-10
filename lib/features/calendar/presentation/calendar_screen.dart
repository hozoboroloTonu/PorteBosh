import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../class_routine/data/routine_repository.dart';
import '../../exams/data/exams_repository.dart';
import '../../assignments/data/assignments_repository.dart';
import '../../courses/data/courses_repository.dart';
import '../../../core/utils/weekday.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../app/theme/tokens.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final routines = ref.watch(allRoutineStreamProvider).asData?.value ?? [];
    final exams = ref.watch(allExamsStreamProvider).asData?.value ?? [];
    final tasks = ref.watch(allAssignmentsStreamProvider).asData?.value ?? [];
    final courses = ref.watch(coursesStreamProvider).asData?.value ?? [];

    final currentWeekday = Weekday.fromDateTime(_selectedDate);
    final todayRoutines = routines.where((r) => r.weekday == currentWeekday).toList();
    final todayExams = exams.where((e) => AcademicDateUtils.isToday(e.startsAt)).toList();
    final todayTasks = tasks.where((t) => t.deadlineAt != null && AcademicDateUtils.isToday(t.deadlineAt!)).toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Academic Agenda',
        subtitle: AcademicDateUtils.formatDate(_selectedDate),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'Jump to Today',
            onPressed: () => setState(() => _selectedDate = DateTime.now()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Weekly Routine (${currentWeekday.fullName})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (todayRoutines.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No classes scheduled for this day of the week.', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...todayRoutines.map((r) {
              final course = courses.firstWhere((c) => c.id == r.courseId, orElse: () => courses.first);
              return Card(
                child: ListTile(
                  leading: Container(width: 4, height: 40, color: course.color),
                  title: Text('${course.name} (${r.titleOrType ?? "Class"})'),
                  subtitle: Text('${r.timeFormatted} • Room: ${r.room ?? "TBD"}'),
                ),
              );
            }),
          const SizedBox(height: AppSpacing.lg),
          const Text('Exams & Deadlines Today', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          if (todayExams.isEmpty && todayTasks.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No exams or assignment deadlines due today.', style: TextStyle(color: Colors.grey)),
              ),
            )
          else ...[
            ...todayExams.map((e) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.assignment_late, color: AppColors.overdue),
                    title: Text(e.title),
                    subtitle: const Text('Exam Scheduled Today'),
                  ),
                )),
            ...todayTasks.map((t) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.task_alt, color: AppColors.upcoming),
                    title: Text(t.title),
                    subtitle: const Text('Assignment Deadline Today'),
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
