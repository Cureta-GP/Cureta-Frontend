import 'package:cureta/features/ocr/data/service/ocr_service.dart';

import '../models/ocr_medicine_match.dart';
import '../models/ocr_confirm_response.dart';

class OcrRepository {
  final OcrService service;

  OcrRepository(this.service);

  Future<List<OcrMedicineMatch>> scan(String filePath) async {
    final response = await service.scanPrescription(
      filePath: filePath,
    );

    return response.extractedMedicines;
  }

  Future<OcrConfirmResponse> confirm({
    required List<OcrMedicineMatch> medicines,
    required String profileId,
  }) async {
    final names = medicines
        .map((e) => e.corrected ?? e.original)
        .toList();

    return await service.confirmMedicines(
      medicines: names,
      profileId: profileId,
    );
  }
}