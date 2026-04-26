import 'package:cureta/features/ocr/data/models/ocr_medicine_match.dart';

class OcrScanResponse {
  final bool success;
  final List<OcrMedicineMatch> extractedMedicines;
  final String? message;

  OcrScanResponse({
    required this.success,
    required this.extractedMedicines,
    this.message,
  });

  factory OcrScanResponse.fromJson(Map<String, dynamic> json) {
    return OcrScanResponse(
      success: json['success'] ?? false,
      extractedMedicines: (json['extractedMedicines'] as List)
          .map((e) => OcrMedicineMatch.fromJson(e))
          .toList(),
      message: json['message'],
    );
  }
}
