import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class EyeDetector {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/models/eye_detection_model.tflite');
    print('Eye detection model loaded successfully');
  }

  Future<bool> isEyeDetected(File imageFile) async {
    try {
      final input = await _preprocessImage(imageFile);
      // Output shape
      var output = List.filled(1 * 1, 0.0).reshape([1, 1]);
      _interpreter.run(input, output);
      double confidence = output[0][0];
      // Inverted condition: closer to 0 means eye is present
      return confidence < 0.6; // Correct threshold check
    } catch (e) {
      print('Error during eye detection: $e');
      return false;
    }
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    final imageData = img.decodeImage(await imageFile.readAsBytes());
    if (imageData == null) throw Exception('Failed to decode image');

    // Ensure these dimensions match your model's input requirements
    final resizedImage = img.copyResize(imageData, width: 128, height: 128);

    // Normalize pixel values to [0, 1]
    return List.generate(
      1,
      (index) => List.generate(
        128,
        (y) => List.generate(
          128,
          (x) => List.generate(
            3,
            (c) => resizedImage.getPixel(x, y)[c].toDouble() / 255.0,
          ),
        ),
      ),
    );
  }

  Future<void> dispose() async {
    _interpreter.close();
  }
}