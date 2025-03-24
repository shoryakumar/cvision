import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'model_predictor.dart';

class MobileNetPredictor extends ModelPredictor {
  @override
  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(
          'assets/models/cataract_detection_model_mobilenetv2.tflite');
      print("Model loaded successfully.");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  @override
  Future<List<String>> processImage(File imageFile) async {
    try {
      final input = await preprocessImage(imageFile);
      var output = List.filled(1 * 2, 0).reshape([1, 2]);

      interpreter.run(input, output);

      var results = output[0] as List<double>;
      final classes = ['Cataract', 'Normal'];

      return List.generate(
        results.length,
        (i) => '${classes[i]}: ${(results[i] * 100).toStringAsFixed(2)}%',
      );
    } catch (e) {
      print("Error processing image: $e");
      return ["Error: Unable to process image"];
    }
  }
}
