import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notes_repository.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../app/theme/tokens.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final String? noteId;
  final String courseId;

  const NoteEditorScreen({Key? key, this.noteId, required this.courseId}) : super(key: key);

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.noteId == null ? 'New Note' : 'Edit Note',
        subtitle: _isSaving ? 'Saving...' : 'Saved locally',
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveAndExit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Note Title...',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _bodyController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Start typing notes...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAndExit() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isNotEmpty || body.isNotEmpty) {
      setState(() => _isSaving = true);
      await ref.read(notesRepositoryProvider).saveNote(
        id: widget.noteId,
        courseId: widget.courseId,
        title: title.isEmpty ? 'Untitled Note' : title,
        body: body,
      );
    }
    if (mounted) Navigator.of(context).pop();
  }
}
