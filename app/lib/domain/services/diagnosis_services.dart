import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../../core/utils/probability_fusion.dart';

class PreDiagnosisEngine {
  Map<String, double> score({
    required Questionnaire questionnaire,
    required List<Disease> diseases,
    required Map<String, String> answers,
  }) {
    final scores = {
      for (final disease in diseases) disease.id: questionnaire.initialScore,
    };

    for (final question in questionnaire.questions) {
      final answer = answers[question.id];
      if (answer == null) continue;
      final effect = question.effects[answer];
      if (effect == null) continue;

      _applyEffect(scores, effect['boost'] as Map<String, dynamic>?);
      _applyEffect(scores, effect['reduce'] as Map<String, dynamic>?, reduce: true);
    }

    return _normalize(scores);
  }

  void _applyEffect(
    Map<String, double> scores,
    Map<String, dynamic>? effect, {
    bool reduce = false,
  }) {
    if (effect == null) return;
    effect.forEach((diseaseId, value) {
      if (!scores.containsKey(diseaseId)) return;
      final delta = (value as num).toDouble();
      scores[diseaseId] = reduce
          ? (scores[diseaseId]! - delta).clamp(0.0, 1.0)
          : (scores[diseaseId]! + delta).clamp(0.0, 1.0);
    });
  }

  Map<String, double> _normalize(Map<String, double> scores) {
    final maxValue = scores.values.fold<double>(0, (a, b) => a > b ? a : b);
    if (maxValue <= 0) return scores;
    return {
      for (final entry in scores.entries) entry.key: (entry.value / maxValue).clamp(0.0, 1.0),
    };
  }
}

class DiagnosisOrchestrator {
  DiagnosisOrchestrator({
    required DiagnosisRepository diagnosisRepository,
    required HistoryRepository historyRepository,
  })  : _diagnosisRepository = diagnosisRepository,
        _historyRepository = historyRepository;

  final DiagnosisRepository _diagnosisRepository;
  final HistoryRepository _historyRepository;

  Future<DiagnosisResult> diagnose({
    required String cropId,
    required List<Disease> diseases,
    required Questionnaire questionnaire,
    required Map<String, String> answers,
    required List<int> imageBytes,
    String? imagePath,
  }) async {
    final preScores = _diagnosisRepository.runPreDiagnosis(
      questionnaire: questionnaire,
      diseases: diseases,
      answers: answers,
    );
    final visionScores = await _diagnosisRepository.runVisionDiagnosis(
      diseases: diseases,
      imageBytes: imageBytes,
    );
    final result = _diagnosisRepository.fuseResults(
      diseases: diseases,
      preScores: preScores,
      visionScores: visionScores,
    );

    await _historyRepository.save(
      DiagnosisRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cropId: cropId,
        diseaseId: result.disease.id,
        timestamp: DateTime.now(),
        preDiagnosisScore: result.preDiagnosisScore,
        visionScore: result.visionScore,
        mergedScore: result.mergedScore,
        answers: answers,
        imagePath: imagePath,
      ),
    );

    return result;
  }
}

double previewFusion(double pre, double vision) => ProbabilityFusion.merge(pre, vision);
