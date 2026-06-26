/// Represents the drug interaction data returned by the backend
/// when a newly added medicine may conflict with existing ones.
class DrugInteractionModel {
  final bool hasInteraction;
  final List<InteractionDetail> interactions;

  const DrugInteractionModel({
    required this.hasInteraction,
    this.interactions = const [],
  });

  factory DrugInteractionModel.fromJson(Map<String, dynamic> json) {
    final list = json['interactions'] as List<dynamic>? ?? [];
    return DrugInteractionModel(
      hasInteraction: json['hasInteraction'] as bool? ?? false,
      interactions: list
          .whereType<Map<String, dynamic>>()
          .map(InteractionDetail.fromJson)
          .toList(),
    );
  }
}

/// A single drug-drug interaction entry.
class InteractionDetail {
  final String medicine;
  final String severity;
  final String description;

  const InteractionDetail({
    required this.medicine,
    required this.severity,
    required this.description,
  });

  factory InteractionDetail.fromJson(Map<String, dynamic> json) {
    return InteractionDetail(
      medicine: json['medicine'] as String? ?? '',
      severity: json['severity'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
