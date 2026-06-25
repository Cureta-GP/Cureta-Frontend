import 'package:cureta/features/medicines/data/models/drug_interaction_model.dart';
import 'ocr_created_medicine.dart';

class OcrConfirmResponse {
  final bool success;
  final List<String> checked;
  final List<String> duplicates;
  final List<OcrCreatedMedicine> created;
  final String? message;
  final DrugInteractionModel? drugInteractions;

  OcrConfirmResponse({
    required this.success,
    required this.checked,
    required this.duplicates,
    required this.created,
    this.message,
    this.drugInteractions,
  });

  factory OcrConfirmResponse.fromJson(Map<String, dynamic> json) {
    DrugInteractionModel? parsedInteractions;

    // Check root level
    if (json['drug_interactions'] != null) {
      parsedInteractions =
          DrugInteractionModel.fromJson(json['drug_interactions']);
    }
    // Check nested inside 'data'
    else if (json['data'] is Map && json['data']['drug_interactions'] != null) {
      parsedInteractions =
          DrugInteractionModel.fromJson(json['data']['drug_interactions']);
    }

    return OcrConfirmResponse(
      success: json['success'] ?? false,
      checked: List<String>.from(json['checked'] ?? []),
      duplicates: List<String>.from(json['duplicates'] ?? []),
      created:
          (json['created'] as List?)
              ?.map(
                (e) => OcrCreatedMedicine.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      message: json['message'],
      drugInteractions: parsedInteractions,
    );
  }
}
