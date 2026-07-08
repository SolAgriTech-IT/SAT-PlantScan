import 'package:flutter/material.dart';

import '../../../core/di/app_locator.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _language = 'fr';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final code = await settingsRepo.getLanguageCode();
    setState(() => _language = code);
  }

  Future<void> _setLanguage(String code) async {
    await settingsRepo.setLanguageCode(code);
    setState(() => _language = code);
    satAppKey.currentState?.setLocale(Locale(code));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modelReady = AppLocator.instance.visionDataSource.isReady;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.modelStatus),
            subtitle: Text(modelReady ? l10n.modelReady : l10n.modelFallback),
            leading: Icon(
              modelReady ? Icons.memory : Icons.warning_amber_rounded,
              color: modelReady ? Colors.green : Colors.orange,
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.selectLanguage),
            subtitle: Text(_language == 'fr' ? l10n.french : l10n.english),
          ),
          RadioListTile<String>(
            title: Text(l10n.french),
            value: 'fr',
            groupValue: _language,
            onChanged: (value) => value == null ? null : _setLanguage(value),
          ),
          RadioListTile<String>(
            title: Text(l10n.english),
            value: 'en',
            groupValue: _language,
            onChanged: (value) => value == null ? null : _setLanguage(value),
          ),
        ],
      ),
    );
  }
}
