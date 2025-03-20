import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/exams_repository.dart';
import '../../../app/theme/tokens.dart';

Future<void> showExamEditDialog(BuildContext context, {required String courseId}) async {
  await showDialog(
    context: context,
    builder: (ctx) => _ExamEditDialog(courseId: courseId),
  );
}

class _ExamEditDialog extends ConsumerStatefulWidget {
  final String courseId;

  const _ExamEditDialog({Key? key, required this.courseId}) : super(key: key);

  @override
  ConsumerState<_ExamEditDialog> createState() => _ExamEditDialogState();
}

class _ExamEditDialogState extends ConsumerState<_ExamEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  DateTime _startsAt = DateTime.now().add(const Duration(days: 14));

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Schedule Exam'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Exam Title *',
                  hintText: 'e.g. Midterm Examination',
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                icon: const Icon(Icons.event),
                label: Text('Date: ${_startsAt.day}/${_startsAt.month}/${_startsAt.year}'),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startsAt,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _startsAt = picked);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            await ref.read(examsRepositoryProvider).addExam(
              courseId: widget.courseId,
              title: _titleController.text.trim(),
              startsAt: _startsAt,
            );
            if (mounted) Navigator.of(context).pop();
          },
          child: const Text('Schedule'),
        ),
      ],
    );
  }
}
