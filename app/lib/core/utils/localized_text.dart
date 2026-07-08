class LocalizedText {
  const LocalizedText({required this.fr, required this.en});

  final String fr;
  final String en;

  String forLocale(String languageCode) => languageCode == 'fr' ? fr : en;

  factory LocalizedText.fromJson(Map<String, dynamic> json) {
    return LocalizedText(
      fr: json['fr'] as String? ?? '',
      en: json['en'] as String? ?? '',
    );
  }
}

class LocalizedList {
  const LocalizedList({required this.fr, required this.en});

  final List<String> fr;
  final List<String> en;

  List<String> forLocale(String languageCode) => languageCode == 'fr' ? fr : en;

  factory LocalizedList.fromJson(Map<String, dynamic> json) {
    return LocalizedList(
      fr: (json['fr'] as List<dynamic>? ?? []).cast<String>(),
      en: (json['en'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}
