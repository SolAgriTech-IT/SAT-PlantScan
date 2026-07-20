import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/knowledge_local_datasource.dart';

class KnowledgeRepositoryImpl implements KnowledgeRepository {
  KnowledgeRepositoryImpl(this._dataSource);

  final KnowledgeLocalDataSource _dataSource;

  Future<void> warmUp() => _dataSource.warmUp();

  bool get isWarm => _dataSource.isWarm;

  List<Crop> get cachedCrops => _dataSource.cachedCrops;

  KnowledgeBundle? bundleForCrop(String cropId) => _dataSource.bundleForCrop(cropId);

  @override
  Future<List<Crop>> getAvailableCrops() => _dataSource.loadCrops();

  @override
  Future<Crop> getCrop(String cropId) => _dataSource.loadCrop(cropId);

  @override
  Future<List<Disease>> getDiseases(String cropId) => _dataSource.loadDiseases(cropId);

  @override
  Future<Disease> getDisease(String cropId, String diseaseId) =>
      _dataSource.loadDisease(cropId, diseaseId);

  @override
  Future<Questionnaire> getQuestionnaire(String cropId) =>
      _dataSource.loadQuestionnaire(cropId);
}
