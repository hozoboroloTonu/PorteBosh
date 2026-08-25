import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portebosh/features/class_routine/presentation/widgets/weekday_selector.dart';
import 'package:portebosh/core/utils/weekday.dart';

void main() {
  testWidgets('WeekdaySelector renders 7 days with Saturday first', (tester) async {
    Weekday? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeekdaySelector(
            selectedDay: Weekday.sat,
            activeDays: const {Weekday.sat, Weekday.mon},
            courseAccentColor: const Color(0xFF176B5B),
            onDaySelected: (day) => selected = day,
          ),
        ),
      ),
    );

    expect(find.text('SAT'), findsOneWidget);
    expect(find.text('SUN'), findsOneWidget);
    expect(find.text('MON'), findsOneWidget);
    expect(find.text('TUE'), findsOneWidget);
    expect(find.text('WED'), findsOneWidget);
    expect(find.text('THU'), findsOneWidget);
    expect(find.text('FRI'), findsOneWidget);

    await tester.tap(find.text('MON'));
    await tester.pump();
    expect(selected, Weekday.mon);
  });
}
