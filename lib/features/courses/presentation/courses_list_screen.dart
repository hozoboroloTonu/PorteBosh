import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/courses_repository.dart';
import '../domain/course_model.dart';
import 'course_edit_dialog.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../app/theme/tokens.dart';

class CoursesListScreen extends ConsumerStatefulWidget {
  const CoursesListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends ConsumerState<CoursesListScreen> {
  bool _showArchived = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesStreamProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Courses',
        subtitle: 'Academic subjects and workspaces',
        actions: [
          IconButton(
            icon: Icon(_showArchived ? Icons.archive : Icons.archive_outlined),
            tooltip: _showArchived ? 'Hide archived' : 'Show archived',
            onPressed: () {
              setState(() => _showArchived = !_showArchived);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCourseEditDialog(context),
        child: const Icon(Icons.add),
      ),
      body: coursesAsync.when(
        loading: () => const AppLoadingIndicator(message: 'Loading courses...'),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (courses) {
          final filtered = courses.where((c) {
            if (!_showArchived && c.isArchived) return false;
            if (_searchQuery.isNotEmpty) {
              final q = _searchQuery.toLowerCase();
              final matchesName = c.name.toLowerCase().contains(q);
              final matchesCode = c.code?.toLowerCase().contains(q) ?? false;
              return matchesName || matchesCode;
            }
            return true;
          }).toList();

          if (filtered.isEmpty) {
            return EmptyStateView(
              icon: Icons.school_outlined,
              title: _searchQuery.isEmpty ? 'No courses yet' : 'No matching courses',
              description: _searchQuery.isEmpty
                  ? 'Add your first semester course to manage routines, lecture slides, and notes.'
                  : 'Try searching with another keyword.',
              actionLabel: _searchQuery.isEmpty ? 'Create Course' : null,
              onAction: _searchQuery.isEmpty ? () => showCourseEditDialog(context) : null,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (ctx, idx) {
              final course = filtered[idx];
              return _CourseCard(course: course);
            },
          );
        },
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;

  const _CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.md),
        onTap: () => context.push('/courses/${course.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 52,
                decoration: BoxDecoration(
                  color: course.color,
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (course.code != null && course.code!.isNotEmpty)
                      Text(
                        course.code!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: course.color,
                          letterSpacing: 0.5,
                        ),
                      ),
                    Text(
                      course.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    if (course.instructor != null && course.instructor!.isNotEmpty)
                      Text(
                        course.instructor!,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
