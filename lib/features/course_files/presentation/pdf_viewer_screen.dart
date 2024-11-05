import 'package:flutter/material.dart';
import '../../../core/widgets/custom_app_bar.dart';

class PdfViewerScreen extends StatefulWidget {
  final String storedRelativePath;
  final String title;

  const PdfViewerScreen({
    Key? key,
    required this.storedRelativePath,
    required this.title,
  }) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int _currentPage = 1;
  int _totalPages = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        subtitle: 'Page $_currentPage of $_totalPages',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'PDF Render Engine Active (Local File)',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
            ),
            Text('$_currentPage / $_totalPages'),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
            ),
          ],
        ),
      ),
    );
  }
}
