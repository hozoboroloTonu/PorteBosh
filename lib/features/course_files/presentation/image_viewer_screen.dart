import 'package:flutter/material.dart';
import '../../../core/widgets/custom_app_bar.dart';

class ImageViewerScreen extends StatelessWidget {
  final String storedRelativePath;
  final String title;

  const ImageViewerScreen({
    Key? key,
    required this.storedRelativePath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: title,
        showBottomDivider: false,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image, size: 80, color: Colors.white54),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
