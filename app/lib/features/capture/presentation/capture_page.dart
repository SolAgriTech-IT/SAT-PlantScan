import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/di/app_locator.dart';
import '../../../core/widgets/capture_guide_overlay.dart';
import '../../../l10n/app_localizations.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({
    super.key,
    required this.cropId,
    required this.answers,
    required this.recommendedTargets,
  });

  final String cropId;
  final Map<String, String> answers;
  final List<String> recommendedTargets;

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  bool _loading = false;

  String _targetLabel(AppLocalizations l10n, String target) {
    switch (target) {
      case 'leaflet':
        return l10n.captureLeaflet;
      case 'stem':
        return l10n.captureStem;
      case 'root':
        return l10n.captureRoot;
      default:
        return l10n.captureLeaf;
    }
  }

  Future<void> _pick(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 85);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() => _imageBytes = bytes);
  }

  Future<void> _analyze() async {
    if (_imageBytes == null) return;
    setState(() => _loading = true);
    try {
      final diseases = await knowledgeRepo.getDiseases(widget.cropId);
      final questionnaire = await knowledgeRepo.getQuestionnaire(widget.cropId);
      final result = await diagnosisOrchestrator.diagnose(
        cropId: widget.cropId,
        diseases: diseases,
        questionnaire: questionnaire,
        answers: widget.answers,
        imageBytes: _imageBytes!.toList(),
      );
      if (!mounted) return;
      context.push('/result', extra: {'cropId': widget.cropId, 'result': result});
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.captureTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _StepChip(label: l10n.stepQuestionnaire, done: true),
                _StepChip(label: l10n.stepCapture, active: true),
                _StepChip(label: l10n.stepResult),
              ],
            ),
            const SizedBox(height: 12),
            Text(l10n.captureHint),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: widget.recommendedTargets
                  .map(
                    (target) => Chip(
                      avatar: const Icon(Icons.camera_alt, size: 16),
                      label: Text(_targetLabel(l10n, target)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade100,
                    ),
                    child: _imageBytes == null
                        ? const Center(child: Icon(Icons.image, size: 72, color: Colors.grey))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                          ),
                  ),
                  if (_imageBytes == null) const CaptureGuideOverlay(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera),
                    label: Text(l10n.camera),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: Text(l10n.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _imageBytes == null || _loading ? null : _analyze,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(l10n.analyze),
            ),
          ],
        ),
      ),
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
          backgroundColor: active ? color.withValues(alpha: 0.08) : null,
        ),
      ),
    );
  }
}
