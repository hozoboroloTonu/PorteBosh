import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portebosh/core/widgets/empty_state_view.dart';

void main() {
  testWidgets('EmptyStateView renders title, description, and action callback', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyStateView(
            icon: Icons.school_outlined,
            title: 'No Courses Yet',
            description: 'Get started by creating your first course.',
            actionLabel: 'Create Course',
            onAction: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('No Courses Yet'), findsOneWidget);
    expect(find.text('Get started by creating your first course.'), findsOneWidget);
    expect(find.text('Create Course'), findsOneWidget);

    await tester.tap(find.text('Create Course'));
    expect(tapped, isTrue);
  });
}
