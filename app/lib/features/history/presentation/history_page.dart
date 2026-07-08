import 'package:flutter/material.dart';

import '../../../core/di/app_locator.dart';
import '../../../l10n/app_localizations.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<_HistoryItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_HistoryItem>> _load() async {
    final language = await settingsRepo.getLanguageCode();
    final records = await historyRepo.getAll();
    final items = <_HistoryItem>[];
    for (final record in records) {
      final disease = await knowledgeRepo.getDisease(record.cropId, record.diseaseId);
      items.add(
        _HistoryItem(
          title: disease.commonName.forLocale(language),
          date: record.timestamp,
          score: record.mergedScore,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: FutureBuilder<List<_HistoryItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return Center(child: Text(l10n.noHistory));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text(item.date.toLocal().toString()),
                trailing: Text('${(item.score * 100).toStringAsFixed(0)}%'),
              );
            },
          );
        },
      ),
    );
  }
}

class _HistoryItem {
  _HistoryItem({required this.title, required this.date, required this.score});

  final String title;
  final DateTime date;
  final double score;
}
