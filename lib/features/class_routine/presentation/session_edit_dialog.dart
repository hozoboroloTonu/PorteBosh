import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/routine_repository.dart';
import '../domain/routine_model.dart';
import '../../../../core/utils/weekday.dart';
import '../../../../core/utils/time_utils.dart';
import '../../../../app/theme/tokens.dart';

Future<void> showSessionEditDialog(
  BuildContext context, {
  required String courseId,
  required Weekday defaultWeekday,
  RoutineSession? sessionToEdit,
}) async {
  await showDialog(
    context: context,
    builder: (ctx) => _SessionEditDialog(
      courseId: courseId,
      defaultWeekday: defaultWeekday,
      sessionToEdit: sessionToEdit,
    ),
  );
}

class _SessionEditDialog extends ConsumerStatefulWidget {
  final String courseId;
  final Weekday defaultWeekday;
  final RoutineSession? sessionToEdit;

  const _SessionEditDialog({
    Key? key,
    required this.courseId,
    required this.defaultWeekday,
    this.sessionToEdit,
  }) : super(key: key);

  @override
  ConsumerState<_SessionEditDialog> createState() => _SessionEditDialogState();
}

class _SessionEditDialogState extends ConsumerState<_SessionEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late Weekday _selectedWeekday;
  late int _startMinute;
  late int _endMinute;
  late TextEditingController _titleController;
  late TextEditingController _roomController;
  late TextEditingController _instructorController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final s = widget.sessionToEdit;
    _selectedWeekday = s?.weekday ?? widget.defaultWeekday;
    _startMinute = s?.startMinute ?? 9 * 60; // 09:00 AM
    _endMinute = s?.endMinute ?? 10 * 60 + 30; // 10:30 AM
    _titleController = TextEditingController(text: s?.titleOrType ?? 'Lecture');
    _roomController = TextEditingController(text: s?.room ?? '');
    _instructorController = TextEditingController(text: s?.instructor ?? '');
    _noteController = TextEditingController(text: s?.note ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _roomController.dispose();
    _instructorController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.sessionToEdit != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Class Session' : 'Add Class Session'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<Weekday>(
                value: _selectedWeekday,
                decoration: const InputDecoration(labelText: 'Day of Week'),
                items: Weekday.saturdayFirst.map((day) {
                  return DropdownMenuItem(value: day, child: Text(day.fullName));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedWeekday = val);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickTime(isStart: true),
                      child: Text('Start: ${TimeUtils.formatMinutes(_startMinute)}'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickTime(isStart: false),
                      child: Text('End: ${TimeUtils.formatMinutes(_endMinute)}'),
                    ),
                  ),
                ],
              ),
              if (_endMinute <= _startMinute)
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'End time must be after start time',
                    style: TextStyle(color: AppColors.overdue, fontSize: 12),
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Session Type / Title',
                  hintText: 'e.g. Lecture, Lab, Tutorial',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(
                  labelText: 'Room / Building (Optional)',
                  hintText: 'e.g. Room 402, Science Bldg',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _instructorController,
                decoration: const InputDecoration(
                  labelText: 'Instructor Override (Optional)',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _endMinute > _startMinute ? _save : null,
          child: Text(isEditing ? 'Save Changes' : 'Add Session'),
        ),
      ],
    );
  }

  Future<void> _pickTime({required bool isStart}) async {
    final current = TimeUtils.fromMinuteOfDay(isStart ? _startMinute : _endMinute);
    final picked = await showTimePicker(context: context, initialTime: current);
    if (picked != null) {
      final minutes = TimeUtils.toMinuteOfDay(picked);
      setState(() {
        if (isStart) {
          _startMinute = minutes;
        } else {
          _endMinute = minutes;
        }
      });
    }
  }

  void _save() async {
    final repo = ref.read(routineRepositoryProvider);
    if (widget.sessionToEdit != null) {
      final updated = widget.sessionToEdit!.copyWith(
        weekday: _selectedWeekday,
        startMinute: _startMinute,
        endMinute: _endMinute,
        titleOrType: _titleController.text.trim(),
        room: _roomController.text.trim(),
        instructor: _instructorController.text.trim(),
      );
      await repo.updateSession(updated);
    } else {
      await repo.addSession(
        courseId: widget.courseId,
        weekday: _selectedWeekday,
        startMinute: _startMinute,
        endMinute: _endMinute,
        titleOrType: _titleController.text.trim(),
        room: _roomController.text.trim(),
        instructor: _instructorController.text.trim(),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }
}
