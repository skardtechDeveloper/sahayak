import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class NepaliOCRService {
  Interpreter? _interpreter;
  TextRecognizer? _textRecognizer;

  Future<void> initialize() async {
    // Initialize Google ML Kit for general OCR
    _textRecognizer = GoogleMlKit.vision.textRecognizer();

    // Load custom Nepali TFLite model
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/models/nepali_ocr.tflite');
    } catch (e) {
      print('Failed to load Nepali OCR model: $e');
    }
  }

  Future<String> recognizeTextFromImage(File imageFile) async {
    try {
      // Preprocess image
      final processedImage = await _preprocessImage(imageFile);

      // Try Nepali-specific model first
      if (_interpreter != null) {
        final nepaliText = await _recognizeWithCustomModel(processedImage);
        if (nepaliText.isNotEmpty) return nepaliText;
      }

      // Fallback to Google ML Kit
      return await _recognizeWithMLKit(imageFile);
    } catch (e) {
      return 'OCR असफल भयो: $e';
    }
  }

  Future<img.Image> _preprocessImage(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    var image = img.decodeImage(imageBytes)!;

    // Convert to grayscale
    image = img.grayscale(image);

    // Increase contrast
    image = img.adjustColor(image, contrast: 1.5);

    // Apply Gaussian blur (reduce noise)
    image = img.gaussianBlur(image, radius: 1);

    return image;
  }

  Future<String> _recognizeWithCustomModel(img.Image image) async {
    final input = _prepareImageForModel(image);
    final output = List.filled(1, List.filled(100, 0.0)).reshape([1, 100]);

    _interpreter!.run(input, output);

    // Convert output to text
    return _decodeModelOutput(output as List<List<double>>);
  }

  Future<String> _recognizeWithMLKit(File imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final recognizedText = await _textRecognizer!.processImage(inputImage);

    String result = '';
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        result += '${line.text}\n';
      }
    }

    return result.trim();
  }

  List<dynamic> _prepareImageForModel(img.Image image) {
    // Resize to 128x128
    image = img.copyResize(image, width: 128, height: 128);

    // Convert to float array normalized to [-1, 1]
    final pixels = List<double>.filled(128 * 128, 0.0);
    int index = 0;

    for (var y = 0; y < 128; y++) {
      for (var x = 0; x < 128; x++) {
        final pixel = image.getPixel(x, y);
        // Direct calculation without unused variables
        final gray =
            (pixel.r * 255.0 + pixel.g * 255.0 + pixel.b * 255.0) / 3.0;
        pixels[index++] = (gray / 127.5) - 1.0;
      }
    }
    return [pixels].reshape([1, 128, 128, 1]);
  }

  String _decodeModelOutput(List<List<double>> output) {
    // Map model output indices to Nepali characters
    const nepaliChars = 'अआइईउऊएऐओऔकखगघङचछजझञटठडढणतथदधनपफबभमयरलवशषसहक्षत्रज्ञ';

    final decoded = StringBuffer();
    for (final prediction in output[0]) {
      if (prediction > 0.5) {
        final charIndex = (prediction * nepaliChars.length).toInt();
        if (charIndex < nepaliChars.length) {
          decoded.write(nepaliChars[charIndex]);
        }
      }
    }

    return decoded.toString();
  }

  void dispose() {
    _interpreter?.close();
    _textRecognizer?.close();
  }
}
