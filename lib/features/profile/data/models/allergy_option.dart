import 'package:easy_localization/easy_localization.dart';

enum AllergyOption {
  food,
  dairy,
  drug,
  respiratory,
  skin,
  insect,
  pet,
  noAllergy,
  other,
}

extension AllergyOptionX on AllergyOption {
  int get id => switch (this) {
    AllergyOption.food => 1,
    AllergyOption.dairy => 2,
    AllergyOption.drug => 3,
    AllergyOption.respiratory => 4,
    AllergyOption.skin => 5,
    AllergyOption.insect => 6,
    AllergyOption.pet => 7,
    AllergyOption.noAllergy => 8,
    AllergyOption.other => 9,
  };

  String get backendName => switch (this) {
    AllergyOption.food => 'food',
    AllergyOption.dairy => 'dairy',
    AllergyOption.drug => 'drug',
    AllergyOption.respiratory => 'respiratory',
    AllergyOption.skin => 'skin',
    AllergyOption.insect => 'insect',
    AllergyOption.pet => 'pet',
    AllergyOption.noAllergy => 'no_allergy',
    AllergyOption.other => 'other',
  };

  String get localizationKey =>
      'profiles.steps.medical_conditions.$backendName';

  String get localizedName => localizationKey.tr();

  static AllergyOption? fromBackendName(String value) {
    for (final option in AllergyOption.values) {
      if (option.backendName == value) return option;
    }
    return null;
  }
}
