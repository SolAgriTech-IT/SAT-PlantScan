import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sat_plantscan/core/di/app_locator.dart';
import 'package:sat_plantscan/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    AppLocator.resetForTesting();
    SharedPreferences.setMockInitialValues({});
    await AppLocator.instance.init();
  });

  testWidgets('navigate to crop list after start diagnosis', (tester) async {
    await tester.pumpWidget(SatPlantScanApp(key: satAppKey));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    final startFr = find.text('Démarrer un diagnostic');
    final startEn = find.text('Start diagnosis');
    if (startFr.evaluate().isNotEmpty) {
      await tester.tap(startFr);
    } else {
      await tester.tap(startEn);
    }
    await tester.pumpAndSettle();

    expect(find.text('Choisir la culture'), findsOneWidget);
    expect(find.text('Manioc'), findsOneWidget);
  });
}
