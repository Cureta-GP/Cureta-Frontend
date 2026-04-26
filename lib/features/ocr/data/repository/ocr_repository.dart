import '../service/ocr_service.dart';
import '../models/ocr_scan_response.dart';
import '../models/ocr_confirm_response.dart';

class OcrRepository {
  final OcrService service;

  OcrRepository({required this.service});

  Future<OcrScanResponse> scanPrescription(String filePath) async {
    return service.scanPrescription(filePath: filePath);
  }

  Future<OcrConfirmResponse> confirmMedicines({
    required List<String> medicines,
    required String profileId,
  }) async {
    return service.confirmMedicines(medicines: medicines, profileId: profileId);
  }
}
