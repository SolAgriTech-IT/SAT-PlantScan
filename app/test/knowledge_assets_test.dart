import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sat_plantscan/data/datasources/knowledge_local_datasource.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('knowledge assets load and warmUp succeeds', () async {
    const manifest = 'assets/knowledge/crops/cassava/manifest.json';
    const diseases = 'assets/knowledge/crops/cassava/diseases.json';
    const questionnaire = 'assets/knowledge/crops/cassava/questionnaire.json';

    await rootBundle.loadString(manifest);
    await rootBundle.loadString(diseases);
    await rootBundle.loadString(questionnaire);

    final dataSource = KnowledgeLocalDataSource();
    await dataSource.warmUp();
    final crops = await dataSource.loadCrops();
    expect(crops, isNotEmpty);
    expect(crops.first.id, 'cassava');
  });
}
