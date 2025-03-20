import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/exams_repository.dart';
import '../domain/exam_model.dart';
import 'exam_edit_dialog.dart';
import '../../courses/domain/course_model.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/utils/date_utils.dart';
import '../../../app/theme/tokens.dart';

class ExamsTabView extends ConsumerWidget {
  final Course course;

  const ExamsTabView({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examsAsync = ref.watch(allExamsStreamProvider);

    return examsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (allExams) {
        final exams = allExams.where((e) => e.courseId == course.id).toList();

        if (exams.isEmpty) {
          return EmptyStateView(
            icon: Icons.quiz_outlined,
            title: 'No exams scheduled',
            description: 'Schedule midterms, quizzes, and final exams with syllabus coverage.',
            actionLabel: 'Schedule Exam',
            onAction: () => showExamEditDialog(context, courseId: course.id),
          );
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => showExamEditDialog(context, courseId: course.id),
            child: const Icon(Icons.add),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: exams.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (ctx, idx) {
              final exam = exams[idx];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.assignment_turned_in_outlined, color: AppColors.accentLight),
                  title: Text(exam.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Date: ${AcademicDateUtils.formatDate(exam.startsAt)}'),
                  trailing: exam.acquiredMarks != null && exam.totalMarks != null
                      ? Chip(label: Text('${exam.acquiredMarks} / ${exam.totalMarks}'))
                      : null,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
