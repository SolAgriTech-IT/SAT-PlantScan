import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/history_local_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._dataSource);

  final HistoryLocalDataSource _dataSource;

  Future<void> _ensureReady() => _dataSource.init();

  @override
  Future<void> clear() async {
    await _ensureReady();
    return _dataSource.clear();
  }

  @override
  Future<List<DiagnosisRecord>> getAll() async {
    await _ensureReady();
    return _dataSource.loadAll();
  }

  @override
  Future<void> save(DiagnosisRecord record) async {
    await _ensureReady();
    return _dataSource.save(record);
  }
}
