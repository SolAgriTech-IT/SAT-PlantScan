import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/datasources/history_local_datasource.dart';
import '../../data/datasources/knowledge_local_datasource.dart';
import '../../data/datasources/settings_local_datasource.dart';
import '../../data/datasources/vision_tflite_datasource.dart';
import '../../data/repositories/diagnosis_repository_impl.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../data/repositories/knowledge_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/diagnosis_services.dart';

class AppLocator {
  static final AppLocator instance = AppLocator._();
  AppLocator._();

  late final SettingsRepository settingsRepository;
  late final KnowledgeRepositoryImpl knowledgeRepository;
  late final HistoryRepository historyRepository;
  late final DiagnosisRepository diagnosisRepository;
  late final PreDiagnosisEngine preDiagnosisEngine;
  late final DiagnosisOrchestrator diagnosisOrchestrator;
  late final VisionTfliteDataSource visionDataSource;

  String cachedLanguageCode = 'fr';
  List<Crop> cachedCrops = const [];

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;

    final settingsDs = SettingsLocalDataSource();
    await settingsDs.init().timeout(const Duration(seconds: 10));
    settingsRepository = SettingsRepositoryImpl(settingsDs);

    final knowledgeDs = KnowledgeLocalDataSource();
    knowledgeRepository = KnowledgeRepositoryImpl(knowledgeDs);
    await knowledgeRepository.warmUp().timeout(const Duration(seconds: 15));

    cachedLanguageCode = await settingsRepository.getLanguageCode();
    cachedCrops = await knowledgeRepository.getAvailableCrops();

    final historyDs = HistoryLocalDataSource();
    historyRepository = HistoryRepositoryImpl(historyDs);

    visionDataSource = VisionTfliteDataSource();

    preDiagnosisEngine = PreDiagnosisEngine();
    diagnosisRepository = DiagnosisRepositoryImpl(
      visionDataSource: visionDataSource,
      preDiagnosisEngine: preDiagnosisEngine,
    );
    diagnosisOrchestrator = DiagnosisOrchestrator(
      diagnosisRepository: diagnosisRepository,
      historyRepository: historyRepository,
    );

    _initialized = true;
  }

  /// Resets bootstrap state between widget tests.
  @visibleForTesting
  static void resetForTesting() {
    instance._initialized = false;
    instance.cachedCrops = const [];
    instance.cachedLanguageCode = 'fr';
  }
}

SettingsRepository get settingsRepo => AppLocator.instance.settingsRepository;
KnowledgeRepository get knowledgeRepo => AppLocator.instance.knowledgeRepository;
HistoryRepository get historyRepo => AppLocator.instance.historyRepository;
DiagnosisRepository get diagnosisRepo => AppLocator.instance.diagnosisRepository;
DiagnosisOrchestrator get diagnosisOrchestrator =>
    AppLocator.instance.diagnosisOrchestrator;
