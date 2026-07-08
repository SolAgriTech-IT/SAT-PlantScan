import '../entities/entities.dart';

abstract class KnowledgeRepository {
  Future<List<Crop>> getAvailableCrops();
  Future<Crop> getCrop(String cropId);
  Future<List<Disease>> getDiseases(String cropId);
  Future<Disease> getDisease(String cropId, String diseaseId);
  Future<Questionnaire> getQuestionnaire(String cropId);
}

abstract class DiagnosisRepository {
  Map<String, double> runPreDiagnosis({
    required Questionnaire questionnaire,
    required List<Disease> diseases,
    required Map<String, String> answers,
  });

  Future<Map<String, double>> runVisionDiagnosis({
    required List<Disease> diseases,
    required List<int> imageBytes,
  });

  DiagnosisResult fuseResults({
    required List<Disease> diseases,
    required Map<String, double> preScores,
    required Map<String, double> visionScores,
  });
}

abstract class HistoryRepository {
  Future<List<DiagnosisRecord>> getAll();
  Future<void> save(DiagnosisRecord record);
  Future<void> clear();
}

abstract class SettingsRepository {
  Future<String> getLanguageCode();
  Future<void> setLanguageCode(String code);
}
