import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/app_locator.dart';
import '../../../domain/entities/entities.dart';
import '../../../l10n/app_localizations.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key, required this.cropId});

  final String cropId;

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  late Future<_QuestionnaireViewModel> _future;
  int _index = 0;
  final Map<String, String> _answers = {};

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_QuestionnaireViewModel> _load() async {
    final language = await settingsRepo.getLanguageCode();
    final questionnaire = await knowledgeRepo.getQuestionnaire(widget.cropId);
    final diseases = await knowledgeRepo.getDiseases(widget.cropId);
    return _QuestionnaireViewModel(
      language: language,
      questionnaire: questionnaire,
      diseases: diseases,
    );
  }

  void _onAnswer(String questionId, String value) {
    setState(() => _answers[questionId] = value);
  }

  Future<void> _finish(_QuestionnaireViewModel data) async {
    final preScores = diagnosisRepo.runPreDiagnosis(
      questionnaire: data.questionnaire,
      diseases: data.diseases,
      answers: _answers,
    );
    final ranked = preScores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topDisease = data.diseases.firstWhere((d) => d.id == ranked.first.key);
    if (!mounted) return;
    context.push(
      '/capture/${widget.cropId}',
      extra: {
        'answers': _answers,
        'targets': topDisease.recommendedCaptureTargets,
      },
    );
  }

  String _sectionLabel(AppLocalizations l10n, String type) {
    return type == 'abiotic' ? l10n.abioticSection : l10n.bioticSection;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.questionnaireTitle)),
      body: FutureBuilder<_QuestionnaireViewModel>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          final questions = data.questionnaire.questions;
          final question = questions[_index];
          final selected = _answers[question.id];

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _StepChip(label: l10n.stepQuestionnaire, active: true),
                    _StepChip(label: l10n.stepCapture),
                    _StepChip(label: l10n.stepResult),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: (_index + 1) / questions.length),
                const SizedBox(height: 8),
                Text(l10n.questionProgress(_index + 1, questions.length)),
                const SizedBox(height: 12),
                Chip(
                  avatar: Icon(
                    question.type == 'abiotic' ? Icons.cloud : Icons.bug_report,
                    size: 16,
                  ),
                  label: Text(_sectionLabel(l10n, question.type)),
                ),
                const SizedBox(height: 8),
                Text(
                  question.text.forLocale(data.language),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                ...question.options.map(
                  (option) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: RadioListTile<String>(
                      title: Text(option.label.forLocale(data.language)),
                      value: option.value,
                      groupValue: selected,
                      onChanged: (value) {
                        if (value != null) _onAnswer(question.id, value);
                      },
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    if (_index > 0)
                      OutlinedButton(
                        onPressed: () => setState(() => _index -= 1),
                        child: Text(l10n.previous),
                      ),
                    const Spacer(),
                    FilledButton(
                      onPressed: selected == null
                          ? null
                          : () {
                              if (_index < questions.length - 1) {
                                setState(() => _index += 1);
                              } else {
                                _finish(data);
                              }
                            },
                      child: Text(_index < questions.length - 1 ? l10n.next : l10n.finish),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  const _StepChip({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? Theme.of(context).colorScheme.primary : Colors.grey;
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

class _QuestionnaireViewModel {
  _QuestionnaireViewModel({
    required this.language,
    required this.questionnaire,
    required this.diseases,
  });

  final String language;
  final Questionnaire questionnaire;
  final List<Disease> diseases;
}
