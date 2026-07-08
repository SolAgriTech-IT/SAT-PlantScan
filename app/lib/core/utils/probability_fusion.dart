class ProbabilityFusion {
  const ProbabilityFusion._();

  /// Combines independent probabilities: P = 1 - (1-a)(1-b)
  static double merge(double preDiagnosis, double vision) {
    final pre = preDiagnosis.clamp(0.0, 1.0);
    final vis = vision.clamp(0.0, 1.0);
    return 1.0 - (1.0 - pre) * (1.0 - vis);
  }

  static Map<String, double> mergeMaps(
    Map<String, double> preScores,
    Map<String, double> visionScores,
  ) {
    final ids = {...preScores.keys, ...visionScores.keys};
    return {
      for (final id in ids)
        id: merge(preScores[id] ?? 0.0, visionScores[id] ?? 0.0),
    };
  }
}
