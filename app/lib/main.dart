import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/app_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

final GlobalKey<SatPlantScanAppState> satAppKey = GlobalKey<SatPlantScanAppState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocator.instance.init();
  runApp(SatPlantScanApp(key: satAppKey));
}

class SatPlantScanApp extends StatefulWidget {
  const SatPlantScanApp({super.key});

  @override
  State<SatPlantScanApp> createState() => SatPlantScanAppState();
}

class SatPlantScanAppState extends State<SatPlantScanApp> {
  Locale _locale = const Locale('fr');
  late final _router = AppRouter.create();

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final code = await settingsRepo.getLanguageCode();
    setState(() => _locale = Locale(code));
  }

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SAT-PlantScan',
      theme: AppTheme.light(),
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
