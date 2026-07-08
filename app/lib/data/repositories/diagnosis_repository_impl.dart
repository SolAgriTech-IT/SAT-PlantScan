import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/diagnosis_services.dart';
import '../../core/utils/probability_fusion.dart';
import '../datasources/vision_tflite_datasource.dart';

class DiagnosisRepositoryImpl implements DiagnosisRepository {
  DiagnosisRepositoryImpl({
    required VisionTfliteDataSource visionDataSource,
    required PreDiagnosisEngine preDiagnosisEngine,
  })  : _visionDataSource = visionDataSource,
        _preDiagnosisEngine = preDiagnosisEngine;

  final VisionTfliteDataSource _visionDataSource;
  final PreDiagnosisEngine _preDiagnosisEngine;

  @override
  Map<String, double> runPreDiagnosis({
    required Questionnaire questionnaire,
    required List<Disease> diseases,
    required Map<String, String> answers,
  }) {
    return _preDiagnosisEngine.score(
      questionnaire: questionnaire,
      diseases: diseases,
      answers: answers,
    );
  }

  @override
  Future<Map<String, double>> runVisionDiagnosis({
    required List<Disease> diseases,
    required List<int> imageBytes,
  }) {
    return _visionDataSource.classify(diseases: diseases, imageBytes: imageBytes);
  }

  @override
  DiagnosisResult fuseResults({
    required List<Disease> diseases,
    required Map<String, double> preScores,
    required Map<String, double> visionScores,
  }) {
    final merged = ProbabilityFusion.mergeMaps(preScores, visionScores);
    final ranked = merged.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topId = ranked.first.key;
    final disease = diseases.firstWhere((item) => item.id == topId);
    return DiagnosisResult(
      disease: disease,
      preDiagnosisScore: preScores[topId] ?? 0,
      visionScore: visionScores[topId] ?? 0,
      mergedScore: merged[topId] ?? 0,
      rankedCandidates: ranked.take(5).toList(),
    );
  }
}
