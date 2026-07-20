import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/app_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

final GlobalKey<SatPlantScanAppState> satAppKey = GlobalKey<SatPlantScanAppState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initError;
  try {
    await AppLocator.instance.init();
  } catch (error) {
    initError = error.toString();
  }
  runApp(SatPlantScanApp(key: satAppKey, initError: initError));
}

class SatPlantScanApp extends StatefulWidget {
  const SatPlantScanApp({super.key, this.initError});

  final String? initError;

  @override
  State<SatPlantScanApp> createState() => SatPlantScanAppState();
}

class SatPlantScanAppState extends State<SatPlantScanApp> {
  late Locale _locale = Locale(AppLocator.instance.cachedLanguageCode);
  late final _router = AppRouter.create();

  @override
  void initState() {
    super.initState();
    if (widget.initError == null && AppLocator.instance.isInitialized) {
      _locale = Locale(AppLocator.instance.cachedLanguageCode);
    }
  }

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initError != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Erreur au démarrage:\n${widget.initError}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

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
