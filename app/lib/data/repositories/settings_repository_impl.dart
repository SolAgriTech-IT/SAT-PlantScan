import '../../domain/repositories/repositories.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._dataSource);

  final SettingsLocalDataSource _dataSource;

  @override
  Future<String> getLanguageCode() => _dataSource.getLanguageCode();

  @override
  Future<void> setLanguageCode(String code) => _dataSource.setLanguageCode(code);
}
