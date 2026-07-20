import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/app_locator.dart';
import '../../../l10n/app_localizations.dart';

class CropSelectionPage extends StatelessWidget {
  const CropSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locator = AppLocator.instance;

    if (!locator.isInitialized || !locator.knowledgeRepository.isWarm) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.selectCrop)),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Base de connaissances non chargée.\nRedémarrez l\'application.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final language = locator.cachedLanguageCode;
    final crops = locator.cachedCrops;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectCrop)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: crops.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final crop = crops[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.grass)),
              title: Text(crop.displayName.forLocale(language)),
              subtitle: Text(crop.description.forLocale(language)),
              trailing: crop.enabled ? const Icon(Icons.arrow_forward_ios) : null,
              enabled: crop.enabled,
              onTap: crop.enabled ? () => context.push('/questionnaire/${crop.id}') : null,
            ),
          );
        },
      ),
    );
  }
}
