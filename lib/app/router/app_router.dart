import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/courses/presentation/courses_list_screen.dart';
import '../../features/courses/presentation/course_workspace_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/assignments/presentation/tasks_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/about_screen.dart';
import '../../features/backup/presentation/backup_restore_screen.dart';
import '../../features/course_files/presentation/pdf_viewer_screen.dart';
import '../../features/course_files/presentation/image_viewer_screen.dart';
import '../../features/notes/presentation/note_editor_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (idx) => navigationShell.goBranch(idx),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Courses'),
              NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Calendar'),
              NavigationDestination(icon: Icon(Icons.task_alt_outlined), selectedIcon: Icon(Icons.task_alt), label: 'Tasks'),
              NavigationDestination(icon: Icon(Icons.more_horiz), selectedIcon: Icon(Icons.more_horiz), label: 'More'),
            ],
          ),
        );
      },
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/', builder: (_, __) => const DashboardScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/courses', builder: (_, __) => const CoursesListScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/tasks', builder: (_, __) => const TasksScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/more', builder: (_, __) => const SettingsScreen())]),
      ],
    ),
    GoRoute(
      path: '/courses/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => CourseWorkspaceScreen(courseId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/pdf-viewer',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final path = state.uri.queryParameters['path'] ?? '';
        final title = state.uri.queryParameters['title'] ?? 'PDF Document';
        return PdfViewerScreen(storedRelativePath: path, title: title);
      },
    ),
    GoRoute(
      path: '/image-viewer',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final path = state.uri.queryParameters['path'] ?? '';
        final title = state.uri.queryParameters['title'] ?? 'Image';
        return ImageViewerScreen(storedRelativePath: path, title: title);
      },
    ),
    GoRoute(
      path: '/notes/new',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final courseId = state.uri.queryParameters['courseId'] ?? '';
        return NoteEditorScreen(courseId: courseId);
      },
    ),
    GoRoute(
      path: '/notes/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final noteId = state.pathParameters['id'];
        final courseId = state.uri.queryParameters['courseId'] ?? '';
        return NoteEditorScreen(noteId: noteId, courseId: courseId);
      },
    ),
    GoRoute(path: '/backup', parentNavigatorKey: _rootNavigatorKey, builder: (_, __) => const BackupRestoreScreen()),
    GoRoute(path: '/about', parentNavigatorKey: _rootNavigatorKey, builder: (_, __) => const AboutScreen()),
  ],
);
