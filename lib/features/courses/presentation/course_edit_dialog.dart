import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/courses_repository.dart';
import '../domain/course_model.dart';
import '../../../app/theme/tokens.dart';

Future<void> showCourseEditDialog(BuildContext context, {Course? courseToEdit}) async {
  await showDialog(
    context: context,
    builder: (ctx) => _CourseEditDialog(courseToEdit: courseToEdit),
  );
}

class _CourseEditDialog extends ConsumerStatefulWidget {
  final Course? courseToEdit;

  const _CourseEditDialog({Key? key, this.courseToEdit}) : super(key: key);

  @override
  ConsumerState<_CourseEditDialog> createState() => _CourseEditDialogState();
}

class _CourseEditDialogState extends ConsumerState<_CourseEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _instructorController;
  late TextEditingController _semesterController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    final c = widget.courseToEdit;
    _nameController = TextEditingController(text: c?.name ?? '');
    _codeController = TextEditingController(text: c?.code ?? '');
    _instructorController = TextEditingController(text: c?.instructor ?? '');
    _semesterController = TextEditingController(text: c?.semester ?? '');
    _selectedColor = c?.color ?? AppColors.coursePalette.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _instructorController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.courseToEdit != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Course' : 'Create Course'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name *',
                  hintText: 'e.g. Data Structures & Algorithms',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a course name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Course Code (Optional)',
                  hintText: 'e.g. CSE-201',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _instructorController,
                decoration: const InputDecoration(
                  labelText: 'Instructor (Optional)',
                  hintText: 'e.g. Dr. Rahman',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _semesterController,
                decoration: const InputDecoration(
                  labelText: 'Semester / Term (Optional)',
                  hintText: 'e.g. Fall 2024',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Accent Color', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppColors.coursePalette.map((col) {
                  final isSelected = col.value == _selectedColor.value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = col),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: col,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                        boxShadow: isSelected ? [const BoxShadow(color: Colors.black26, blurRadius: 4)] : null,
                      ),
                      child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                    ),
                  );
                }).toList(),
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
          child: Text(isEditing ? 'Save Changes' : 'Create'),
        ),
      ],
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(coursesRepositoryProvider);
    if (widget.courseToEdit != null) {
      final updated = widget.courseToEdit!.copyWith(
        name: _nameController.text.trim(),
        code: _codeController.text.trim(),
        instructor: _instructorController.text.trim(),
        semester: _semesterController.text.trim(),
        color: _selectedColor,
      );
      await repo.updateCourse(updated);
    } else {
      await repo.createCourse(
        name: _nameController.text.trim(),
        code: _codeController.text.trim(),
        instructor: _instructorController.text.trim(),
        semester: _semesterController.text.trim(),
        color: _selectedColor,
      );
    }
    if (mounted) Navigator.of(context).pop();
  }
}
