import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import '../models/medical_record_model.dart';
import '../services/medical_record_service.dart';

class MedicalRecordRepository {
  final MedicalRecordService _service;

  // ── Session Cache ──
  List<MedicalRecordModel>? _cachedRecords;
  String? _cachedProfileId;

  MedicalRecordRepository(this._service);

  // ── GET RECORDS (new) ──
  Future<List<MedicalRecordModel>> getRecords({
    required String profileId,
    String? type,
    String? search,
    bool forceRefresh = false,
  }) async {
    try {
      // Return session cache instantly if no refresh forced and no filters
      final hasFilters = type != null || (search != null && search.isNotEmpty);
      if (!forceRefresh &&
          !hasFilters &&
          _cachedRecords != null &&
          _cachedProfileId == profileId) {
        return _cachedRecords!;
      }

      final response = await _service.getRecords(
        profileId: profileId,
        type: type,
        search: search,
      );

      final data = response.data['data'] as List<dynamic>?;
      if (data == null) return [];

      final records = data
          .map((e) => MedicalRecordModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Only cache the unfiltered full list
      if (!hasFilters) {
        _cachedRecords = records;
        _cachedProfileId = profileId;
      }

      return records;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // ── CREATE (existing) ──
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

      final newRecord = MedicalRecordModel.fromJson(data);

      // Prepend to session cache so list screen sees it immediately
      if (_cachedProfileId == profileId) {
        _cachedRecords?.insert(0, newRecord);
      }

      return newRecord;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
