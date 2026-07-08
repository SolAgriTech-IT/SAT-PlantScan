import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [Locale('en'), Locale('fr')];

  static final Map<String, Map<String, String>> _values = {
    'en': {
      'appTitle': 'SAT-PlantScan',
      'splashTagline': 'Smart plant disease diagnosis',
      'dashboardTitle': 'Dashboard',
      'startDiagnosis': 'Start diagnosis',
      'selectCrop': 'Select crop',
      'selectLanguage': 'Language',
      'french': 'French',
      'english': 'English',
      'questionnaireTitle': 'Pre-diagnosis',
      'next': 'Next',
      'previous': 'Previous',
      'finish': 'Finish',
      'captureTitle': 'Capture image',
      'captureHint':
          'Place the leaf in the frame with uniform background and good lighting.',
      'analyze': 'Analyze',
      'resultTitle': 'Diagnosis result',
      'preDiagnosis': 'Pre-diagnosis',
      'vision': 'Computer vision',
      'mergedResult': 'Merged result',
      'recommendations': 'Recommendations',
      'viewDetails': 'View details',
      'historyTitle': 'History',
      'settingsTitle': 'Settings',
      'aboutTitle': 'About',
      'aboutDescription':
          'SAT-PlantScan is an open-source mobile app by SolAgriTech for tropical plant disease diagnosis.',
      'offlineMode': 'Works offline after installation',
      'confidence': 'Confidence',
      'yes': 'Yes',
      'no': 'No',
      'healthyPlant': 'Healthy plant',
      'noHistory': 'No diagnosis yet',
      'cropCassava': 'Cassava',
      'captureLeaf': 'Leaf',
      'captureLeaflet': 'Leaflet',
      'captureStem': 'Stem',
      'captureRoot': 'Root',
      'severityLow': 'Low',
      'severityMedium': 'Medium',
      'severityHigh': 'High',
      'severityCritical': 'Critical',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'bioticSection': 'Biotic questions',
      'abioticSection': 'Abiotic / environment',
      'questionProgress': 'Question {current} / {total}',
      'topCandidates': 'Other possible diagnoses',
      'modelStatus': 'Vision model status',
      'modelReady': 'TensorFlow Lite model loaded',
      'modelFallback': 'Heuristic mode (train ML model for full vision)',
      'stepQuestionnaire': '1. Questionnaire',
      'stepCapture': '2. Photo',
      'stepResult': '3. Result',
    },
    'fr': {
      'appTitle': 'SAT-PlantScan',
      'splashTagline': 'Diagnostic intelligent des maladies des plantes',
      'dashboardTitle': 'Tableau de bord',
      'startDiagnosis': 'Démarrer un diagnostic',
      'selectCrop': 'Choisir la culture',
      'selectLanguage': 'Langue',
      'french': 'Français',
      'english': 'Anglais',
      'questionnaireTitle': 'Pré-diagnostic',
      'next': 'Suivant',
      'previous': 'Précédent',
      'finish': 'Terminer',
      'captureTitle': 'Capture d\'image',
      'captureHint':
          'Placez la feuille dans le cadre, avec un fond uniforme et une bonne luminosité.',
      'analyze': 'Analyser',
      'resultTitle': 'Résultat du diagnostic',
      'preDiagnosis': 'Pré-diagnostic',
      'vision': 'Vision par ordinateur',
      'mergedResult': 'Résultat fusionné',
      'recommendations': 'Recommandations',
      'viewDetails': 'Voir la fiche',
      'historyTitle': 'Historique',
      'settingsTitle': 'Paramètres',
      'aboutTitle': 'À propos',
      'aboutDescription':
          'SAT-PlantScan est une application mobile open-source de SolAgriTech pour le diagnostic des maladies des plantes tropicales.',
      'offlineMode': 'Fonctionne hors ligne après installation',
      'confidence': 'Confiance',
      'yes': 'Oui',
      'no': 'Non',
      'healthyPlant': 'Plante saine',
      'noHistory': 'Aucun diagnostic pour le moment',
      'cropCassava': 'Manioc',
      'captureLeaf': 'Feuille',
      'captureLeaflet': 'Foliole',
      'captureStem': 'Tige',
      'captureRoot': 'Racine',
      'severityLow': 'Faible',
      'severityMedium': 'Moyenne',
      'severityHigh': 'Élevée',
      'severityCritical': 'Critique',
      'camera': 'Appareil photo',
      'gallery': 'Galerie',
      'bioticSection': 'Questions biotiques',
      'abioticSection': 'Questions abiotiques / environnement',
      'questionProgress': 'Question {current} / {total}',
      'topCandidates': 'Autres diagnostics possibles',
      'modelStatus': 'Statut du modèle vision',
      'modelReady': 'Modèle TensorFlow Lite chargé',
      'modelFallback': 'Mode heuristique (entraînez le modèle ML pour la vision complète)',
      'stepQuestionnaire': '1. Questionnaire',
      'stepCapture': '2. Photo',
      'stepResult': '3. Résultat',
    },
  };

  String _t(String key) => _values[locale.languageCode]?[key] ?? _values['en']![key]!;

  String get appTitle => _t('appTitle');
  String get splashTagline => _t('splashTagline');
  String get dashboardTitle => _t('dashboardTitle');
  String get startDiagnosis => _t('startDiagnosis');
  String get selectCrop => _t('selectCrop');
  String get selectLanguage => _t('selectLanguage');
  String get french => _t('french');
  String get english => _t('english');
  String get questionnaireTitle => _t('questionnaireTitle');
  String get next => _t('next');
  String get previous => _t('previous');
  String get finish => _t('finish');
  String get captureTitle => _t('captureTitle');
  String get captureHint => _t('captureHint');
  String get analyze => _t('analyze');
  String get resultTitle => _t('resultTitle');
  String get preDiagnosis => _t('preDiagnosis');
  String get vision => _t('vision');
  String get mergedResult => _t('mergedResult');
  String get recommendations => _t('recommendations');
  String get viewDetails => _t('viewDetails');
  String get historyTitle => _t('historyTitle');
  String get settingsTitle => _t('settingsTitle');
  String get aboutTitle => _t('aboutTitle');
  String get aboutDescription => _t('aboutDescription');
  String get offlineMode => _t('offlineMode');
  String get confidence => _t('confidence');
  String get yes => _t('yes');
  String get no => _t('no');
  String get healthyPlant => _t('healthyPlant');
  String get noHistory => _t('noHistory');
  String get cropCassava => _t('cropCassava');
  String get captureLeaf => _t('captureLeaf');
  String get captureLeaflet => _t('captureLeaflet');
  String get captureStem => _t('captureStem');
  String get captureRoot => _t('captureRoot');
  String get severityLow => _t('severityLow');
  String get severityMedium => _t('severityMedium');
  String get severityHigh => _t('severityHigh');
  String get severityCritical => _t('severityCritical');
  String get camera => _t('camera');
  String get gallery => _t('gallery');
  String get bioticSection => _t('bioticSection');
  String get abioticSection => _t('abioticSection');
  String questionProgress(int current, int total) =>
      _t('questionProgress').replaceAll('{current}', '$current').replaceAll('{total}', '$total');
  String get topCandidates => _t('topCandidates');
  String get modelStatus => _t('modelStatus');
  String get modelReady => _t('modelReady');
  String get modelFallback => _t('modelFallback');
  String get stepQuestionnaire => _t('stepQuestionnaire');
  String get stepCapture => _t('stepCapture');
  String get stepResult => _t('stepResult');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
