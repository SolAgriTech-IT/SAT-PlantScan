import '../../core/utils/localized_text.dart';

enum DiseaseCategory {
  viral,
  bacterial,
  fungal,
  phytoplasma,
  nematode,
  pest,
  nutritional,
  abiotic,
  healthy,
}

enum SeverityLevel { low, medium, high, critical }

class Crop {
  const Crop({
    required this.id,
    required this.displayName,
    required this.description,
    required this.enabled,
  });

  final String id;
  final LocalizedText displayName;
  final LocalizedText description;
  final bool enabled;
}

class Disease {
  const Disease({
    required this.id,
    required this.cropId,
    required this.category,
    required this.scientificName,
    required this.commonName,
    required this.affectedOrgans,
    required this.earlySymptoms,
    required this.advancedSymptoms,
    required this.causalAgents,
    required this.vectors,
    required this.favorableFactors,
    required this.climateConditions,
    required this.prevention,
    required this.control,
    required this.severityLevel,
    required this.recommendedCaptureTargets,
    required this.references,
    this.mlClassId,
  });

  final String id;
  final String cropId;
  final DiseaseCategory category;
  final LocalizedText scientificName;
  final LocalizedText commonName;
  final LocalizedList affectedOrgans;
  final LocalizedText earlySymptoms;
  final LocalizedText advancedSymptoms;
  final LocalizedText causalAgents;
  final LocalizedText vectors;
  final LocalizedText favorableFactors;
  final LocalizedText climateConditions;
  final LocalizedList prevention;
  final LocalizedList control;
  final SeverityLevel severityLevel;
  final List<String> recommendedCaptureTargets;
  final List<String> references;
  final int? mlClassId;
}

class QuestionOption {
  const QuestionOption({required this.value, required this.label});

  final String value;
  final LocalizedText label;
}

class QuestionnaireQuestion {
  const QuestionnaireQuestion({
    required this.id,
    required this.type,
    required this.text,
    required this.options,
    required this.effects,
  });

  final String id;
  final String type;
  final LocalizedText text;
  final List<QuestionOption> options;
  final Map<String, Map<String, dynamic>> effects;
}

class Questionnaire {
  const Questionnaire({
    required this.cropId,
    required this.initialScore,
    required this.questions,
  });

  final String cropId;
  final double initialScore;
  final List<QuestionnaireQuestion> questions;
}

class DiagnosisRecord {
  const DiagnosisRecord({
    required this.id,
    required this.cropId,
    required this.diseaseId,
    required this.timestamp,
    required this.preDiagnosisScore,
    required this.visionScore,
    required this.mergedScore,
    required this.answers,
    this.imagePath,
  });

  final String id;
  final String cropId;
  final String diseaseId;
  final DateTime timestamp;
  final double preDiagnosisScore;
  final double visionScore;
  final double mergedScore;
  final Map<String, String> answers;
  final String? imagePath;
}

class DiagnosisResult {
  const DiagnosisResult({
    required this.disease,
    required this.preDiagnosisScore,
    required this.visionScore,
    required this.mergedScore,
    required this.rankedCandidates,
  });

  final Disease disease;
  final double preDiagnosisScore;
  final double visionScore;
  final double mergedScore;
  final List<MapEntry<String, double>> rankedCandidates;
}
