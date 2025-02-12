import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/assignments_repository.dart';
import '../domain/assignment_model.dart';
import '../../courses/data/courses_repository.dart';
import '../../../app/theme/tokens.dart';

Future<void> showAssignmentEditDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (ctx) => const _AssignmentEditDialog(),
  );
}

class _AssignmentEditDialog extends ConsumerStatefulWidget {
  const _AssignmentEditDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<_AssignmentEditDialog> createState() => _AssignmentEditDialogState();
}

class _AssignmentEditDialogState extends ConsumerState<_AssignmentEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  String? _selectedCourseId;
  DateTime? _deadline;
  AssignmentPriority _priority = AssignmentPriority.medium;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(coursesStreamProvider).asData?.value ?? [];
    if (_selectedCourseId == null && courses.isNotEmpty) {
      _selectedCourseId = courses.first.id;
    }

    return AlertDialog(
      title: const Text('Add Assignment'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (courses.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _selectedCourseId,
                  decoration: const InputDecoration(labelText: 'Course'),
                  items: courses.map((c) {
                    return DropdownMenuItem(value: c.id, child: Text(c.name));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCourseId = val),
                ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Assignment Title *',
                  hintText: 'e.g. Lab Report 3',
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(_deadline == null ? 'Set Due Date' : 'Due: ${_deadline!.day}/${_deadline!.month}/${_deadline!.year}'),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 3)),
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _deadline = picked);
                },
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
          onPressed: _save,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate() || _selectedCourseId == null) return;
    await ref.read(assignmentsRepositoryProvider).addAssignment(
      courseId: _selectedCourseId!,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      deadlineAt: _deadline,
      priority: _priority,
    );
    if (mounted) Navigator.of(context).pop();
  }
}
