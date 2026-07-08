import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/about/presentation/about_page.dart';
import '../../features/capture/presentation/capture_page.dart';
import '../../features/crop_selection/presentation/crop_selection_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/disease_detail/presentation/disease_detail_page.dart';
import '../../features/history/presentation/history_page.dart';
import '../../features/questionnaire/presentation/questionnaire_page.dart';
import '../../features/result/presentation/result_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../domain/entities/entities.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter create() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashPage()),
        GoRoute(path: '/home', builder: (_, __) => const DashboardPage()),
        GoRoute(path: '/crops', builder: (_, __) => const CropSelectionPage()),
        GoRoute(
          path: '/questionnaire/:cropId',
          builder: (context, state) =>
              QuestionnairePage(cropId: state.pathParameters['cropId']!),
        ),
        GoRoute(
          path: '/capture/:cropId',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return CapturePage(
              cropId: state.pathParameters['cropId']!,
              answers: Map<String, String>.from(extra['answers'] as Map? ?? {}),
              recommendedTargets:
                  (extra['targets'] as List?)?.cast<String>() ?? const ['leaf'],
            );
          },
        ),
        GoRoute(
          path: '/result',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ResultPage(
              cropId: extra['cropId'] as String,
              result: extra['result'] as DiagnosisResult,
            );
          },
        ),
        GoRoute(
          path: '/disease/:cropId/:diseaseId',
          builder: (context, state) => DiseaseDetailPage(
            cropId: state.pathParameters['cropId']!,
            diseaseId: state.pathParameters['diseaseId']!,
          ),
        ),
        GoRoute(path: '/history', builder: (_, __) => const HistoryPage()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
        GoRoute(path: '/about', builder: (_, __) => const AboutPage()),
      ],
    );
  }
}
