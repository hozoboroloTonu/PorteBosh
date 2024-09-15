import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/courses_repository.dart';
import '../domain/course_model.dart';
import 'course_edit_dialog.dart';
import '../../class_routine/presentation/routine_tab_view.dart';
import '../../class_routine/presentation/session_edit_dialog.dart';
import '../../../../core/utils/weekday.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../app/theme/tokens.dart';

class CourseWorkspaceScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CourseWorkspaceScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  ConsumerState<CourseWorkspaceScreen> createState() => _CourseWorkspaceScreenState();
}

class _CourseWorkspaceScreenState extends ConsumerState<CourseWorkspaceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesStreamProvider);

    return coursesAsync.when(
      loading: () => const Scaffold(body: AppLoadingIndicator(message: 'Loading workspace...')),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (courses) {
        final course = courses.firstWhere(
          (c) => c.id == widget.courseId,
          orElse: () => Course(
            id: '',
            name: 'Course not found',
            color: AppColors.accentLight,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        if (course.id.isEmpty) {
          return const Scaffold(body: Center(child: Text('Course not found')));
        }

        return Scaffold(
          appBar: CustomAppBar(
            title: course.name,
            subtitle: course.code,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => showCourseEditDialog(context, courseToEdit: course),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.overdue),
                onPressed: () => _deleteCourse(course),
              ),
            ],
          ),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: course.color,
                indicatorColor: course.color,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Class Routine'),
                  Tab(text: 'Main Files'),
                  Tab(text: 'Topics'),
                  Tab(text: 'Notes'),
                  Tab(text: 'Tests & Tasks'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _OverviewTab(course: course),
                    RoutineTabView(course: course),
                    _PlaceholderTab(title: 'Main Files', icon: Icons.folder_outlined),
                    _PlaceholderTab(title: 'Topics & Chapters', icon: Icons.topic_outlined),
                    _PlaceholderTab(title: 'Notes', icon: Icons.note_outlined),
                    _PlaceholderTab(title: 'Tests & Tasks', icon: Icons.task_alt_outlined),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteCourse(Course course) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete Course',
      message: 'Are you sure you want to permanently delete "${course.name}" and all associated files and notes?',
      isDestructive: true,
    );
    if (confirmed && mounted) {
      await ref.read(coursesRepositoryProvider).deleteCourse(course.id);
      Navigator.of(context).pop();
    }
  }
}

class _OverviewTab extends StatelessWidget {
  final Course course;

  const _OverviewTab({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 8, height: 28, decoration: BoxDecoration(color: course.color, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(width: AppSpacing.sm),
                    Text(course.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                if (course.instructor != null) ...[
                  const SizedBox(height: 8),
                  Text('Instructor: ${course.instructor}', style: const TextStyle(fontSize: 14)),
                ],
                if (course.semester != null) ...[
                  const SizedBox(height: 4),
                  Text('Semester: ${course.semester}', style: const TextStyle(fontSize: 14)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderTab({Key? key, required this.title, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
