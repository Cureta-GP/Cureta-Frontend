import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cureta/core/Services/dio_helper.dart';

class MedicalRecordService {
  Future<Response> getRecords({
    required String profileId,
    String? type,
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    final query = <String, dynamic>{
      'profile_id': profileId,
      if (type != null) 'type': type,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    return await DioHelper.getData(url: 'medical-records', query: query);
  }

  Future<Response> createRecord({
    required String profileId,
    required String diseaseName,
    String? notes,
    required String recordDate,
    required List<String> attachmentTypes,
    required List<String> filePaths,
  }) async {
    final formData = FormData.fromMap({
      'profile_id': profileId,
      'disease_name': diseaseName,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      'record_date': recordDate,
      // Backend's parseArrayField() does JSON.parse() on strings
      'attachment_types': jsonEncode(attachmentTypes),
    });

    // files WITHOUT [] — multer field name is 'files'
    for (final path in filePaths) {
      formData.files.add(
        MapEntry(
          'files',
          await MultipartFile.fromFile(
            path,
            filename: path.split(RegExp(r'[/\\]')).last,
          ),
        ),
      );
    }

    return await DioHelper.postFormData(url: 'medical-records', data: formData);
  }

  Future<Response> updateRecord({
    required String id,
    required String diseaseName,
    String? notes,
    required String recordDate,
    List<String> removeAttachmentIds = const [],
  }) async {
    return await DioHelper.putData(
      url: 'medical-records/$id',
      data: {
        'disease_name': diseaseName,
        'notes': notes ?? '',
        'record_date': recordDate,
        'remove_attachment_ids': removeAttachmentIds,
      },
    );
  }

  Future<Response> deleteRecord({required String id}) async {
    return await DioHelper.deleteData(url: 'medical-records/$id');
  }
}
