import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softec_project/services/ocr_service.dart';

class ScanTaskScreen extends StatefulWidget {
  const ScanTaskScreen({super.key});

  @override
  State<ScanTaskScreen> createState() => _ScanTaskScreenState();
}

class _ScanTaskScreenState extends State<ScanTaskScreen> {
  final OCRService _ocrService = OCRService();
  String _extractedText = '';
  bool _isProcessing = false;

  Future<void> _processImage(ImageSource source) async {
    setState(() {
      _isProcessing = true;
      _extractedText = '';
    });

    try {
      final image = await _ocrService.pickImage(source);
      if (image == null) return;

      final text = await _ocrService.extractTextFromImage(image);
      setState(() => _extractedText = text ?? 'No text found');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan to Task')),
      body: Column(
        children: [
          // Scan Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScanButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () => _processImage(ImageSource.camera),
              ),
              _buildScanButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () => _processImage(ImageSource.gallery),
              ),
            ],
          ),

          // Results
          Expanded(
            child:
                _isProcessing
                    ? const Center(child: CircularProgressIndicator())
                    : _extractedText.isEmpty
                    ? const Center(child: Text('Scan a document or note'))
                    : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Text(_extractedText),
                    ),
          ),

          // Save Button
          if (_extractedText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () => _saveAsTask(context),
                child: const Text('Create Task from Text'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScanButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        IconButton.filled(onPressed: onTap, icon: Icon(icon), iconSize: 40),
        Text(label),
      ],
    );
  }

  Future<void> _saveAsTask(BuildContext context) async {
    // Implement your task creation logic here
    // Example:
    // final task = Task(title: _extractedText, ...);
    // await TaskProvider().addTask(task);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task created from scan!')));
    Navigator.pop(context);
  }
}
