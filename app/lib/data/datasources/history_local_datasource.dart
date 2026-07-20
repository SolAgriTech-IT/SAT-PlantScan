import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/entities.dart';

class HistoryLocalDataSource {
  static const _boxName = 'diagnosis_history';
  static bool _hiveReady = false;

  Future<void> init() async {
    if (!_hiveReady) {
      await Hive.initFlutter();
      _hiveReady = true;
    }
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<String>(_boxName);
    }
  }

  Box<String> get _box => Hive.box<String>(_boxName);

  Future<List<DiagnosisRecord>> loadAll() async {
    return _box.values.map(_decode).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> save(DiagnosisRecord record) async {
    await _box.put(record.id, _encode(record));
  }

  Future<void> clear() async {
    await _box.clear();
  }

  String _encode(DiagnosisRecord record) {
    return jsonEncode({
      'id': record.id,
      'cropId': record.cropId,
      'diseaseId': record.diseaseId,
      'timestamp': record.timestamp.toIso8601String(),
      'preDiagnosisScore': record.preDiagnosisScore,
      'visionScore': record.visionScore,
      'mergedScore': record.mergedScore,
      'answers': record.answers,
      'imagePath': record.imagePath,
    });
  }

  DiagnosisRecord _decode(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return DiagnosisRecord(
      id: json['id'] as String,
      cropId: json['cropId'] as String,
      diseaseId: json['diseaseId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      preDiagnosisScore: (json['preDiagnosisScore'] as num).toDouble(),
      visionScore: (json['visionScore'] as num).toDouble(),
      mergedScore: (json['mergedScore'] as num).toDouble(),
      answers: (json['answers'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as String),
      ),
      imagePath: json['imagePath'] as String?,
    );
  }
}
