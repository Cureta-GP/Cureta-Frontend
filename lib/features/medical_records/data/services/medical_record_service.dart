import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cureta/core/Services/dio_helper.dart';

class MedicalRecordService {
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
}
