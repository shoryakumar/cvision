import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'model_predictor.dart';

class DenseNetPredictor extends ModelPredictor {
  @override
  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/models/cataract_detection_densenet121.tflite');
  }

  @override
  Future<List<String>> processImage(File imageFile) async {
    final input = await preprocessImage(imageFile);
    var output = List.filled(1 * 2, 0).reshape([1, 2]);

    interpreter.run(input, output);
    var results = output[0] as List<double>;

    final classes = ['Cataract', 'Normal'];
    return List.generate(
      results.length,
      (i) => '${classes[i]}: ${(results[i] * 100).toStringAsFixed(2)}%',
    );
  }
}
