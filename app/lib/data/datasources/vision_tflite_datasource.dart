import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../domain/entities/entities.dart';

class VisionTfliteDataSource {
  static const _modelAsset = 'assets/models/sat_plantscan_cassava.tflite';
  static const _labelsAsset = 'assets/models/labels.txt';

  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isReady = false;

  bool get isReady => _isReady;

  Future<void> init() async {
    try {
      final labelsRaw = await rootBundle.loadString(_labelsAsset);
      _labels = labelsRaw.split('\n').where((line) => line.trim().isNotEmpty).toList();
      _interpreter = await Interpreter.fromAsset(_modelAsset);
      _isReady = true;
    } catch (_) {
      _isReady = false;
    }
  }

  Future<Map<String, double>> classify({
    required List<Disease> diseases,
    required List<int> imageBytes,
  }) async {
    if (!_isReady || _interpreter == null) {
      return _fallbackHeuristic(diseases, imageBytes);
    }

    final input = _preprocess(imageBytes);
    final output = List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);
    _interpreter!.run(input, output);

    final probabilities = output[0] as List<double>;
    final scores = <String, double>{};
    for (var index = 0; index < _labels.length; index++) {
      final label = _labels[index];
      final disease = diseases.firstWhere(
        (item) => item.id == label || _matchesClass(item, label),
        orElse: () => diseases.first,
      );
      scores[disease.id] = probabilities[index];
    }
    return _normalize(scores);
  }

  bool _matchesClass(Disease disease, String label) {
    return disease.id.replaceAll('_', ' ').toLowerCase().contains(label.toLowerCase());
  }

  List<List<List<List<double>>>> _preprocess(List<int> bytes) {
    final decoded = img.decodeImage(Uint8List.fromList(bytes));
    if (decoded == null) {
      throw StateError('Unable to decode image');
    }
    final resized = img.copyResize(decoded, width: 224, height: 224);
    return List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(224, (x) {
          final pixel = resized.getPixel(x, y);
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        }),
      ),
    );
  }

  Map<String, double> _fallbackHeuristic(List<Disease> diseases, List<int> imageBytes) {
    final decoded = img.decodeImage(Uint8List.fromList(imageBytes));
    if (decoded == null) {
      return {for (final disease in diseases) disease.id: 1.0 / diseases.length};
    }

    var greenRatio = 0.0;
    final sampleStep = 8;
    var samples = 0;
    for (var y = 0; y < decoded.height; y += sampleStep) {
      for (var x = 0; x < decoded.width; x += sampleStep) {
        final pixel = decoded.getPixel(x, y);
        if (pixel.g > pixel.r && pixel.g > pixel.b) greenRatio += 1;
        samples += 1;
      }
    }
    greenRatio /= samples;

    final scores = <String, double>{
      for (final disease in diseases) disease.id: 0.05,
    };
    if (greenRatio > 0.55) {
      scores['healthy'] = 0.75;
    } else if (greenRatio < 0.35) {
      scores['chlorosis'] = 0.55;
      scores['leaf_senescence'] = 0.45;
    } else {
      scores['cassava_mosaic_disease'] = 0.35;
      scores['cercosporiosis'] = 0.25;
    }
    return _normalize(scores);
  }

  Map<String, double> _normalize(Map<String, double> scores) {
    final maxValue = scores.values.fold<double>(0, (a, b) => a > b ? a : b);
    if (maxValue <= 0) return scores;
    return {
      for (final entry in scores.entries) entry.key: entry.value / maxValue,
    };
  }

  void dispose() {
    _interpreter?.close();
  }
}
