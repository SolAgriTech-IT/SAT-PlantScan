import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/app_locator.dart';
import '../../../core/widgets/sat_widgets.dart';
import '../../../domain/entities/entities.dart';
import '../../../l10n/app_localizations.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.cropId, required this.result});

  final String cropId;
  final DiagnosisResult result;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future<String> _languageFuture;

  @override
  void initState() {
    super.initState();
    _languageFuture = settingsRepo.getLanguageCode();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final disease = widget.result.disease;
    return FutureBuilder<String>(
      future: _languageFuture,
      builder: (context, snapshot) {
        final language = snapshot.data ?? 'fr';
        return Scaffold(
          appBar: AppBar(title: Text(l10n.resultTitle)),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  _StepChip(label: l10n.stepQuestionnaire, done: true),
                  _StepChip(label: l10n.stepCapture, done: true),
                  _StepChip(label: l10n.stepResult, active: true),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        disease.commonName.forLocale(language),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(disease.scientificName.forLocale(language)),
                      const SizedBox(height: 12),
                      ScoreBar(label: l10n.preDiagnosis, value: widget.result.preDiagnosisScore),
                      ScoreBar(label: l10n.vision, value: widget.result.visionScore),
                      ScoreBar(label: l10n.mergedResult, value: widget.result.mergedScore),
                    ],
                  ),
                ),
              ),
              if (widget.result.rankedCandidates.length > 1) ...[
                const SizedBox(height: 16),
                Text(l10n.topCandidates, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...widget.result.rankedCandidates.skip(1).take(3).map(
                  (entry) => ListTile(
                    dense: true,
                    title: Text(entry.key.replaceAll('_', ' ')),
                    trailing: Text('${(entry.value * 100).toStringAsFixed(0)}%'),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(l10n.recommendations, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...disease.prevention.forLocale(language).map(
                    (item) => ListTile(
                      leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                      title: Text(item),
                    ),
                  ),
              ...disease.control.forLocale(language).map(
                    (item) => ListTile(
                      leading: const Icon(Icons.healing_outlined, color: Colors.orange),
                      title: Text(item),
                    ),
                  ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: l10n.viewDetails,
                onPressed: () => context.push('/disease/${widget.cropId}/${disease.id}'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => context.go('/home'),
                child: Text(l10n.dashboardTitle),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StepChip extends StatelessWidget {
  const _StepChip({required this.label, this.done = false, this.active = false});

  final String label;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = done
        ? Colors.green
        : active
            ? Theme.of(context).colorScheme.primary
            : Colors.grey;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Chip(
          label: Text(label, style: TextStyle(fontSize: 11, color: color)),
          side: BorderSide(color: color),
        ),
      ),
    );
  }
}
