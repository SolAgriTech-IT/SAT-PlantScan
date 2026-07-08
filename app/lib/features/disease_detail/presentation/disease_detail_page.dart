import 'package:flutter/material.dart';

import '../../../core/di/app_locator.dart';
import '../../../domain/entities/entities.dart';
import '../../../l10n/app_localizations.dart';

class DiseaseDetailPage extends StatefulWidget {
  const DiseaseDetailPage({super.key, required this.cropId, required this.diseaseId});

  final String cropId;
  final String diseaseId;

  @override
  State<DiseaseDetailPage> createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> {
  late Future<_DetailViewModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DetailViewModel> _load() async {
    final language = await settingsRepo.getLanguageCode();
    final disease = await knowledgeRepo.getDisease(widget.cropId, widget.diseaseId);
    return _DetailViewModel(language: language, disease: disease);
  }

  String _severity(AppLocalizations l10n, SeverityLevel level) {
    switch (level) {
      case SeverityLevel.low:
        return l10n.severityLow;
      case SeverityLevel.medium:
        return l10n.severityMedium;
      case SeverityLevel.high:
        return l10n.severityHigh;
      case SeverityLevel.critical:
        return l10n.severityCritical;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fiche maladie / Disease sheet')),
      body: FutureBuilder<_DetailViewModel>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          final disease = data.disease;
          final l10n = AppLocalizations.of(context)!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(disease.commonName.forLocale(data.language),
                  style: Theme.of(context).textTheme.headlineSmall),
              Text(disease.scientificName.forLocale(data.language)),
              const SizedBox(height: 8),
              Chip(label: Text(_severity(l10n, disease.severityLevel))),
              _section('Symptômes précoces / Early symptoms',
                  disease.earlySymptoms.forLocale(data.language)),
              _section('Symptômes avancés / Advanced symptoms',
                  disease.advancedSymptoms.forLocale(data.language)),
              _section('Agent responsable / Causal agent',
                  disease.causalAgents.forLocale(data.language)),
              _section('Vecteurs / Vectors', disease.vectors.forLocale(data.language)),
              _section('Prévention / Prevention',
                  disease.prevention.forLocale(data.language).join('\n• ')),
              _section('Lutte / Control', disease.control.forLocale(data.language).join('\n• ')),
              _section('Références / References', disease.references.join('\n')),
            ],
          );
        },
      ),
    );
  }

  Widget _section(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('• $content'),
        ],
      ),
    );
  }
}

class _DetailViewModel {
  _DetailViewModel({required this.language, required this.disease});

  final String language;
  final Disease disease;
}
