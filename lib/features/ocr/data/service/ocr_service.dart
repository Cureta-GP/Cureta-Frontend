import 'package:cureta/core/Services/dio_helper.dart';
import 'package:cureta/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart';

import '../models/ocr_scan_response.dart';
import '../models/ocr_confirm_response.dart';

class OcrService {
  Future<OcrScanResponse> scanPrescription({required String filePath}) async {
    try {
      final formData = FormData.fromMap({
        "prescription": await MultipartFile.fromFile(filePath),
      });

      final response = await DioHelper.postFormData(
        url: ApiEndpoints.scanPrescription,
        data: formData,
      );

      return OcrScanResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception("OCR Scan Failed: ${e.response?.data ?? e.message}");
      }
      throw Exception("OCR Scan Failed: $e");
    }
  }

  Future<OcrConfirmResponse> confirmMedicines({
    required List<String> medicines,
    required String profileId,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: ApiEndpoints.scannedMedicines,
        query: {"profile_id": profileId},
        data: {"medicines": medicines},
      );

      return OcrConfirmResponse.fromJson(response.data);
    } catch (e) {
      throw Exception("OCR Confirm Failed: $e");
    }
  }
}
