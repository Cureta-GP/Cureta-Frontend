import 'package:easy_localization/easy_localization.dart';

enum ChronicDiseaseOption {
  diabetes,
  hypertension,
  heartDisease,
  asthma,
  thyroid,
  arthritis,
  other,
}

extension ChronicDiseaseOptionX on ChronicDiseaseOption {
  int get id => switch (this) {
    ChronicDiseaseOption.diabetes => 1,
    ChronicDiseaseOption.hypertension => 2,
    ChronicDiseaseOption.heartDisease => 3,
    ChronicDiseaseOption.asthma => 4,
    ChronicDiseaseOption.thyroid => 5,
    ChronicDiseaseOption.arthritis => 6,
    ChronicDiseaseOption.other => 7,
  };

  String get backendName => switch (this) {
    ChronicDiseaseOption.diabetes => 'diabetes',
    ChronicDiseaseOption.hypertension => 'hypertension',
    ChronicDiseaseOption.heartDisease => 'heart_disease',
    ChronicDiseaseOption.asthma => 'asthma',
    ChronicDiseaseOption.thyroid => 'thyroid',
    ChronicDiseaseOption.arthritis => 'arthritis',
    ChronicDiseaseOption.other => 'other',
  };

  String get localizationKey =>
      'profiles.steps.medical_conditions.$backendName';

  String get localizedName => localizationKey.tr();

  static ChronicDiseaseOption? fromBackendName(String value) {
    for (final option in ChronicDiseaseOption.values) {
      if (option.backendName == value) return option;
    }
    return null;
  }
}
