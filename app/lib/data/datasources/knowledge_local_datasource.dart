import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/entities/entities.dart';
import '../../core/utils/localized_text.dart';

class KnowledgeLocalDataSource {
  static const _cropManifestAsset = 'assets/knowledge/crops/cassava/manifest.json';
  static const _diseasesAsset = 'assets/knowledge/crops/cassava/diseases.json';
  static const _questionnaireAsset = 'assets/knowledge/crops/cassava/questionnaire.json';

  Future<List<Crop>> loadCrops() async {
    final manifest = await _loadJson(_cropManifestAsset);
    return [_mapCrop(manifest as Map<String, dynamic>)];
  }

  Future<Crop> loadCrop(String cropId) async {
    final crops = await loadCrops();
    return crops.firstWhere((crop) => crop.id == cropId);
  }

  Future<List<Disease>> loadDiseases(String cropId) async {
    final raw = await _loadJsonList(_diseasesAsset);
    return raw
        .cast<Map<String, dynamic>>()
        .where((item) => item['cropId'] == cropId)
        .map(_mapDisease)
        .toList();
  }

  Future<Disease> loadDisease(String cropId, String diseaseId) async {
    final diseases = await loadDiseases(cropId);
    return diseases.firstWhere((disease) => disease.id == diseaseId);
  }

  Future<Questionnaire> loadQuestionnaire(String cropId) async {
    final raw = await _loadJson(_questionnaireAsset) as Map<String, dynamic>;
    if (raw['cropId'] != cropId) {
      throw StateError('Questionnaire not found for crop $cropId');
    }
    return Questionnaire(
      cropId: cropId,
      initialScore: (raw['initialScore'] as num).toDouble(),
      questions: (raw['questions'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(
            (question) => QuestionnaireQuestion(
              id: question['id'] as String,
              type: question['type'] as String,
              text: LocalizedText.fromJson(question['text'] as Map<String, dynamic>),
              options: (question['options'] as List<dynamic>)
                  .cast<Map<String, dynamic>>()
                  .map(
                    (option) => QuestionOption(
                      value: option['value'] as String,
                      label: LocalizedText.fromJson(option['label'] as Map<String, dynamic>),
                    ),
                  )
                  .toList(),
              effects: (question['effects'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(key, value as Map<String, dynamic>),
              ),
            ),
          )
          .toList(),
    );
  }

  Crop _mapCrop(Map<String, dynamic> json) {
    return Crop(
      id: json['id'] as String,
      displayName: LocalizedText.fromJson(json['displayName'] as Map<String, dynamic>),
      description: LocalizedText.fromJson(json['description'] as Map<String, dynamic>),
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  Disease _mapDisease(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] as String,
      cropId: json['cropId'] as String,
      category: _parseCategory(json['category'] as String),
      scientificName: LocalizedText.fromJson(json['scientificName'] as Map<String, dynamic>),
      commonName: LocalizedText.fromJson(json['commonName'] as Map<String, dynamic>),
      affectedOrgans: LocalizedList.fromJson(json['affectedOrgans'] as Map<String, dynamic>),
      earlySymptoms: LocalizedText.fromJson(json['earlySymptoms'] as Map<String, dynamic>),
      advancedSymptoms: LocalizedText.fromJson(json['advancedSymptoms'] as Map<String, dynamic>),
      causalAgents: LocalizedText.fromJson(json['causalAgents'] as Map<String, dynamic>),
      vectors: LocalizedText.fromJson(json['vectors'] as Map<String, dynamic>),
      favorableFactors: LocalizedText.fromJson(json['favorableFactors'] as Map<String, dynamic>),
      climateConditions: LocalizedText.fromJson(json['climateConditions'] as Map<String, dynamic>),
      prevention: LocalizedList.fromJson(json['prevention'] as Map<String, dynamic>),
      control: LocalizedList.fromJson(json['control'] as Map<String, dynamic>),
      severityLevel: _parseSeverity(json['severityLevel'] as String),
      recommendedCaptureTargets:
          (json['recommendedCaptureTargets'] as List<dynamic>).cast<String>(),
      references: (json['references'] as List<dynamic>).cast<String>(),
      mlClassId: json['mlClassId'] as int?,
    );
  }

  DiseaseCategory _parseCategory(String value) {
    return DiseaseCategory.values.firstWhere(
      (item) => item.name == value,
      orElse: () => DiseaseCategory.fungal,
    );
  }

  SeverityLevel _parseSeverity(String value) {
    return SeverityLevel.values.firstWhere(
      (item) => item.name == value,
      orElse: () => SeverityLevel.medium,
    );
  }

  Future<dynamic> _loadJson(String assetPath) async {
    final content = await rootBundle.loadString(assetPath);
    return jsonDecode(content);
  }

  Future<List<dynamic>> _loadJsonList(String assetPath) async {
    final content = await rootBundle.loadString(assetPath);
    return jsonDecode(content) as List<dynamic>;
  }
}
