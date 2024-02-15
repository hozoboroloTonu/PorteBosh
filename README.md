# PorteBosh

Your Academic Life, Beautifully Organized.
Author: Mahmud Tonmoy

PorteBosh is an offline-first academic management application for Android devices. The system organizes courses, weekly schedules, class routines, topic notes, course documentation, assignments, exam preparation checklists, and academic calendars into a single unified local database.

The application operates without remote accounts, cloud synchronization, telemetry, or external network requests. All operational data and imported course materials remain exclusively in device-managed storage.

## Key Features

- Offline-First Architecture: Local storage persistence using SQLite via Drift with foreign key constraints, indexes, and reactive query streams.
- Weekly Class Schedule: Saturday-first three-letter weekday indicator (SAT, SUN, MON, TUE, WED, THU, FRI) with course accent color badges and time conflict detection.
- Course Workspaces: Tabbed navigation providing dedicated views for Overview, Class Routine, Main Files, Topics, Notes, and Tasks & Exams.
- Document and Image Viewers: Native document viewers for local PDF files and high-resolution image attachments with zoom controls.
- Academic Notes: Distraction-free note editor supporting association with courses and specific topics.
- Assignment and Exam Tracking: Structured task management with status progression, submission tracking, and topic checklist progress.
- Unified Academic Calendar: Integrated agenda combining recurring class routines with one-time academic deadlines and examinations.
- Portable Backup System: Versioned JSON backup export and validated archive restore with rollback safeguards.
- Theming System: Material Design 3 interface with semantic color tokens supporting system, light, and dark modes.

## Technical Architecture

The codebase follows a modular, feature-oriented structure with explicit separation of presentation, domain business rules, and data access layers:

- lib/
  - main.dart: Application bootstrap and ProviderScope initialization
  - app/: Application configuration, GoRouter routing, and theme definitions
  - core/: Common utility classes, error types, shared widgets, and file storage services
  - database/: SQLite database controllers, table schemas, and data queries
  - features/: Feature modules organized by functional domain:
    - dashboard/: Daily schedule overview and quick action triggers
    - courses/: Course definitions, color coding, and workspace routing
    - class_routine/: Weekly recurring timetable management
    - course_files/: Managed document storage and viewer interfaces
    - notes/: Course and topic note management
    - assignments/: Course deliverables, priority rankings, and completion states
    - exams/: Examination scheduling and syllabus topic checklists
    - calendar/: Unified daily and weekly agenda aggregation
    - backup/: Local backup generation and restore verification
    - settings/: Appearance settings, storage metrics, and application details

## Dependencies

- Framework: Flutter / Dart
- State Management: flutter_riverpod
- Routing: go_router
- Persistence: drift, sqlite3_flutter_libs
- File Management: path_provider, path, file_picker
- Formatting and Identifiers: intl, uuid

## License

This project is released under the MIT License. See the LICENSE file for details.
