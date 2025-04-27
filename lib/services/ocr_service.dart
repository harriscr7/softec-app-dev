import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCRService {
  final _picker = ImagePicker();
  final _textRecognizer = TextRecognizer();

  Future<String?> extractTextFromImage(XFile image) async {
    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      print("OCR Error: $e");
      return null;
    } finally {
      await _textRecognizer.close();
    }
  }

  Future<XFile?> pickImage(ImageSource source) async {
    return await _picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 90,
    );
  }
}
