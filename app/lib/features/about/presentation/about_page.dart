import 'package:flutter/material.dart';

import '../../../core/widgets/sat_widgets.dart';
import '../../../l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SatLogo(size: 120, showTitle: true),
            const SizedBox(height: 16),
            Text(l10n.aboutDescription, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(l10n.offlineMode, textAlign: TextAlign.center),
            const Spacer(),
            const Text('SolAgriTech © 2026 — MIT License'),
          ],
        ),
      ),
    );
  }
}
