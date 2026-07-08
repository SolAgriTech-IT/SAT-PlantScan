import '../../data/datasources/history_local_datasource.dart';
import '../../data/datasources/knowledge_local_datasource.dart';
import '../../data/datasources/settings_local_datasource.dart';
import '../../data/datasources/vision_tflite_datasource.dart';
import '../../data/repositories/diagnosis_repository_impl.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../data/repositories/knowledge_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/diagnosis_services.dart';

class AppLocator {
  static final AppLocator instance = AppLocator._();
  AppLocator._();

  late final SettingsRepository settingsRepository;
  late final KnowledgeRepository knowledgeRepository;
  late final HistoryRepository historyRepository;
  late final DiagnosisRepository diagnosisRepository;
  late final PreDiagnosisEngine preDiagnosisEngine;
  late final DiagnosisOrchestrator diagnosisOrchestrator;
  late final VisionTfliteDataSource visionDataSource;

  Future<void> init() async {
    final settingsDs = SettingsLocalDataSource();
    await settingsDs.init();
    settingsRepository = SettingsRepositoryImpl(settingsDs);

    final knowledgeDs = KnowledgeLocalDataSource();
    knowledgeRepository = KnowledgeRepositoryImpl(knowledgeDs);

    final historyDs = HistoryLocalDataSource();
    await historyDs.init();
    historyRepository = HistoryRepositoryImpl(historyDs);

    final visionDs = VisionTfliteDataSource();
    await visionDs.init();
    visionDataSource = visionDs;

    preDiagnosisEngine = PreDiagnosisEngine();
    diagnosisRepository = DiagnosisRepositoryImpl(
      visionDataSource: visionDs,
      preDiagnosisEngine: preDiagnosisEngine,
    );
    diagnosisOrchestrator = DiagnosisOrchestrator(
      diagnosisRepository: diagnosisRepository,
      historyRepository: historyRepository,
    );
  }
}

SettingsRepository get settingsRepo => AppLocator.instance.settingsRepository;
KnowledgeRepository get knowledgeRepo => AppLocator.instance.knowledgeRepository;
HistoryRepository get historyRepo => AppLocator.instance.historyRepository;
DiagnosisRepository get diagnosisRepo => AppLocator.instance.diagnosisRepository;
DiagnosisOrchestrator get diagnosisOrchestrator =>
    AppLocator.instance.diagnosisOrchestrator;
