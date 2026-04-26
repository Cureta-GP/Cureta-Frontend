
import 'ocr_created_medicine.dart';

class OcrConfirmResponse {
  final bool success;
  final List<String> checked;
  final List<String> duplicates;
  final List<OcrCreatedMedicine> created;
  final String? message;

  OcrConfirmResponse({
    required this.success,
    required this.checked,
    required this.duplicates,
    required this.created,
    this.message,
  });

  factory OcrConfirmResponse.fromJson(Map<String, dynamic> json) {
    return OcrConfirmResponse(
      success: json['success'] ?? false,
      checked: List<String>.from(json['checked'] ?? []),
      duplicates: List<String>.from(json['duplicates'] ?? []),
      created: (json['created'] as List)
          .map((e) => OcrCreatedMedicine.fromJson(e))
          .toList(),
      message: json['message'],
    );
  }
}