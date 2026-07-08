import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/sat_widgets.dart';
import '../../../l10n/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
        actions: [
          IconButton(onPressed: () => context.push('/settings'), icon: const Icon(Icons.settings)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SatLogo(size: 90, showTitle: true),
                  const SizedBox(height: 12),
                  Text(l10n.offlineMode, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _FlowCard(
            icon: Icons.quiz_outlined,
            title: l10n.stepQuestionnaire,
            subtitle: l10n.questionnaireTitle,
          ),
          _FlowCard(
            icon: Icons.photo_camera_outlined,
            title: l10n.stepCapture,
            subtitle: l10n.captureTitle,
          ),
          _FlowCard(
            icon: Icons.insights_outlined,
            title: l10n.stepResult,
            subtitle: l10n.resultTitle,
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: l10n.startDiagnosis,
            onPressed: () => context.push('/crops'),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: l10n.historyTitle,
            onPressed: () => context.push('/history'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.push('/about'),
            child: Text(l10n.aboutTitle),
          ),
        ],
      ),
    );
  }
}

class _FlowCard extends StatelessWidget {
  const _FlowCard({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
