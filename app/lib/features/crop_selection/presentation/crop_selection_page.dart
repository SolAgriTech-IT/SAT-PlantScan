import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/app_locator.dart';
import '../../../domain/entities/entities.dart';
import '../../../l10n/app_localizations.dart';

class CropSelectionPage extends StatefulWidget {
  const CropSelectionPage({super.key});

  @override
  State<CropSelectionPage> createState() => _CropSelectionPageState();
}

class _CropSelectionPageState extends State<CropSelectionPage> {
  late Future<_CropViewModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_CropViewModel> _load() async {
    final language = await settingsRepo.getLanguageCode();
    final crops = await knowledgeRepo.getAvailableCrops();
    return _CropViewModel(language: language, crops: crops);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectCrop)),
      body: FutureBuilder<_CropViewModel>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.crops.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final crop = data.crops[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.grass)),
                  title: Text(crop.displayName.forLocale(data.language)),
                  subtitle: Text(crop.description.forLocale(data.language)),
                  trailing: crop.enabled ? const Icon(Icons.arrow_forward_ios) : null,
                  enabled: crop.enabled,
                  onTap: crop.enabled ? () => context.push('/questionnaire/${crop.id}') : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CropViewModel {
  _CropViewModel({required this.language, required this.crops});

  final String language;
  final List<Crop> crops;
}
