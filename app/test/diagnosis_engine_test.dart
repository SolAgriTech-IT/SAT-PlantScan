import 'package:flutter_test/flutter_test.dart';
import 'package:sat_plantscan/core/utils/localized_text.dart';
import 'package:sat_plantscan/core/utils/probability_fusion.dart';
import 'package:sat_plantscan/domain/entities/entities.dart';
import 'package:sat_plantscan/domain/services/diagnosis_services.dart';

void main() {
  group('ProbabilityFusion', () {
    test('merges probabilities with complementary formula', () {
      expect(ProbabilityFusion.merge(0.72, 0.95), closeTo(0.986, 0.001));
    });
  });

  group('PreDiagnosisEngine', () {
    test('boosts mosaic when mosaic pattern is yes', () {
      final engine = PreDiagnosisEngine();
      final diseases = [
        const Disease(
          id: 'cassava_mosaic_disease',
          cropId: 'cassava',
          category: DiseaseCategory.viral,
          scientificName: LocalizedText(fr: 'CMD', en: 'CMD'),
          commonName: LocalizedText(fr: 'Mosaïque', en: 'Mosaic'),
          affectedOrgans: LocalizedList(fr: ['Feuilles'], en: ['Leaves']),
          earlySymptoms: LocalizedText(fr: 'e', en: 'e'),
          advancedSymptoms: LocalizedText(fr: 'a', en: 'a'),
          causalAgents: LocalizedText(fr: 'c', en: 'c'),
          vectors: LocalizedText(fr: 'v', en: 'v'),
          favorableFactors: LocalizedText(fr: 'f', en: 'f'),
          climateConditions: LocalizedText(fr: 'cl', en: 'cl'),
          prevention: LocalizedList(fr: ['p'], en: ['p']),
          control: LocalizedList(fr: ['c'], en: ['c']),
          severityLevel: SeverityLevel.critical,
          recommendedCaptureTargets: ['leaf'],
          references: ['ref'],
        ),
        const Disease(
          id: 'healthy',
          cropId: 'cassava',
          category: DiseaseCategory.healthy,
          scientificName: LocalizedText(fr: 'Sain', en: 'Healthy'),
          commonName: LocalizedText(fr: 'Sain', en: 'Healthy'),
          affectedOrgans: LocalizedList(fr: ['Feuilles'], en: ['Leaves']),
          earlySymptoms: LocalizedText(fr: 'e', en: 'e'),
          advancedSymptoms: LocalizedText(fr: 'a', en: 'a'),
          causalAgents: LocalizedText(fr: 'c', en: 'c'),
          vectors: LocalizedText(fr: 'v', en: 'v'),
          favorableFactors: LocalizedText(fr: 'f', en: 'f'),
          climateConditions: LocalizedText(fr: 'cl', en: 'cl'),
          prevention: LocalizedList(fr: ['p'], en: ['p']),
          control: LocalizedList(fr: ['c'], en: ['c']),
          severityLevel: SeverityLevel.low,
          recommendedCaptureTargets: ['leaf'],
          references: ['ref'],
        ),
      ];

      final questionnaire = Questionnaire(
        cropId: 'cassava',
        initialScore: 0.08,
        questions: [
          QuestionnaireQuestion(
            id: 'mosaic_pattern',
            type: 'biotic',
            text: LocalizedText(fr: 'Mosaïque ?', en: 'Mosaic?'),
            options: const [
              QuestionOption(
                value: 'yes',
                label: LocalizedText(fr: 'Oui', en: 'Yes'),
              ),
            ],
            effects: {
              'yes': {
                'boost': {'cassava_mosaic_disease': 0.45},
                'reduce': {'healthy': 0.35},
              },
            },
          ),
        ],
      );

      final scores = engine.score(
        questionnaire: questionnaire,
        diseases: diseases,
        answers: {'mosaic_pattern': 'yes'},
      );

      expect(scores['cassava_mosaic_disease'], greaterThan(scores['healthy']!));
    });
  });
}
