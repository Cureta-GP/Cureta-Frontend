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
    final list = json['extractedMedicines'] ?? json['extracted_medicines'];
    return OcrScanResponse(
      success: json['success'] ?? false,
      extractedMedicines:
          (list as List?)
              ?.map((e) => OcrMedicineMatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      message: json['message'],
    );
  }
}
