import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import '../models/create_record_response_model.dart';
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
      final response = await _service.createRecord(
        profileId: profileId,
        diseaseName: diseaseName,
        notes: notes,
        recordDate: recordDate,
        attachmentTypes: attachmentTypes,
        filePaths: filePaths,
      );

      final parsed = CreateRecordResponseModel.fromJson(response.data);

      if (!parsed.isSuccess) {
        throw AppException.validation(
          msg: parsed.message ?? 'Failed to create medical record',
        );
      }

      return parsed.data!;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
