import 'dart:io';
import 'package:Cvision/models/mobilenet_predictor.dart';
import 'package:Cvision/models/vgg_predictor.dart';
import 'package:Cvision/models/densenet_predictor.dart';
import 'package:Cvision/models/model_predictor.dart';

class CombinedPredictor extends ModelPredictor {
  final List<ModelPredictor> _predictors = [
    MobileNetPredictor(),
    VggPredictor(),
    DenseNetPredictor(),
  ];

  @override
  Future<void> loadModel() async {
    for (var predictor in _predictors) {
      await predictor.loadModel();
    }
  }

  @override
  Future<List<String>> processImage(File imageFile) async {
    final aggregatedScores = [0.0, 0.0];

    for (var predictor in _predictors) {
      final modelResults = await predictor.processImage(imageFile);
      for (int i = 0; i < modelResults.length; i++) {
        final score = double.parse(modelResults[i].split(':')[1].trim().replaceAll('%', '')) / 100.0;
        aggregatedScores[i] += score;
      }
    }

    // Averaging the scores
    final avgScores = aggregatedScores.map((e) => e / _predictors.length).toList();
    final classes = ['Cataract', 'Normal'];

    return List.generate(
      avgScores.length,
      (i) => '${classes[i]}: ${(avgScores[i] * 100).toStringAsFixed(2)}%',
    );
  }

  @override
  Future<void> dispose() async {
    for (var predictor in _predictors) {
      await predictor.dispose();
    }
  }
}