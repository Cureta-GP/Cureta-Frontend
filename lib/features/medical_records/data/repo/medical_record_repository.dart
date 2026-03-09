import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import '../models/medical_record_model.dart';
import '../services/medical_record_service.dart';

class MedicalRecordRepository {
  final MedicalRecordService _service;
  MedicalRecordRepository(this._service);

  Future<MedicalRecordModel> createRecord({
    required String profileId,
    required String diseaseName,
    String? notes,
    required String recordDate,
    required List<String> attachmentTypes,
    required List<String> filePaths,
  }) async {
    try {
      // Dio throws DioException automatically on 4xx/5xx status codes.
      // If we reach the next line, the HTTP status is 2xx (success).
      final response = await _service.createRecord(
        profileId: profileId,
        diseaseName: diseaseName,
        notes: notes,
        recordDate: recordDate,
        attachmentTypes: attachmentTypes,
        filePaths: filePaths,
      );
      final data = response.data['data'];
      if (data == null || data is! Map<String, dynamic>) {
        throw AppException.server(msg: 'No record data returned from server');
      }

      return MedicalRecordModel.fromJson(data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
