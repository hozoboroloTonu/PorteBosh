import 'package:flutter/material.dart';
import '../../../../core/utils/weekday.dart';
import '../../../../app/theme/tokens.dart';

class WeekdaySelector extends StatelessWidget {
  final Weekday selectedDay;
  final Set<Weekday> activeDays;
  final Color courseAccentColor;
  final ValueChanged<Weekday> onDaySelected;

  const WeekdaySelector({
    Key? key,
    required this.selectedDay,
    required this.activeDays,
    required this.courseAccentColor,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: Weekday.saturdayFirst.map((day) {
          final isSelected = day == selectedDay;
          final hasClass = activeDays.contains(day);

          Color backgroundColor;
          Color textColor;

          if (isSelected) {
            backgroundColor = courseAccentColor;
            textColor = Colors.white;
          } else if (hasClass) {
            backgroundColor = courseAccentColor.withOpacity(0.18);
            textColor = courseAccentColor;
          } else {
            backgroundColor = theme.colorScheme.surfaceContainerHighest.withOpacity(0.4);
            textColor = theme.colorScheme.onSurface.withOpacity(0.5);
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              onTap: () => onDaySelected(day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  border: isSelected
                      ? Border.all(color: courseAccentColor, width: 1.5)
                      : hasClass
                          ? Border.all(color: courseAccentColor.withOpacity(0.3), width: 1)
                          : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      day.shortLabel,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected || hasClass ? FontWeight.w700 : FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasClass
                            ? (isSelected ? Colors.white : courseAccentColor)
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
