import 'package:cureta/features/ocr/data/service/ocr_service.dart';

import '../models/ocr_scan_response.dart';
import '../models/ocr_confirm_response.dart';

class OcrRepository {
  final OcrService service;

  OcrRepository(this.service);

  Future<OcrScanResponse> scan(String filePath) async {
    return await service.scanPrescription(filePath: filePath);
  }

  Future<OcrConfirmResponse> confirm({
    required List<String> medicines,
    required String profileId,
  }) async {
    return await service.confirmMedicines(
      medicines: medicines,
      profileId: profileId,
    );
  }
}
