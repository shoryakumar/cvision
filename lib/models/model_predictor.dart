import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

abstract class ModelPredictor {
  late Interpreter interpreter;

  Future<void> loadModel();
  Future<List<String>> processImage(File imageFile);

  Future<void> dispose() async {
    interpreter.close();
  }

  // Shared utility method for image preprocessing
  Future<List<List<List<List<double>>>>> preprocessImage(File imageFile) async {
    final imageData = img.decodeImage(await imageFile.readAsBytes());
    if (imageData == null) throw Exception('Failed to decode image');

    final resizedImage = img.copyResize(imageData, width: 224, height: 224);

    return List.generate(
      1,
      (index) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) => List.generate(
            3,
            (c) => resizedImage.getPixel(x, y)[c].toDouble() / 255.0,
          ),
        ),
      ),
    );
  }
}