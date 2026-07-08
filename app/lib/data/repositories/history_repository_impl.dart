import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/history_local_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._dataSource);

  final HistoryLocalDataSource _dataSource;

  @override
  Future<void> clear() => _dataSource.clear();

  @override
  Future<List<DiagnosisRecord>> getAll() => _dataSource.loadAll();

  @override
  Future<void> save(DiagnosisRecord record) => _dataSource.save(record);
}
