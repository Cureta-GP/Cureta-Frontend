// lib/data/services/profile_service.dart
import 'package:cureta/core/Services/dio_helper.dart';
import 'package:cureta/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart';

class ProfileService {
  Future<Response> getProfiles() async {
    return await DioHelper.getData(
      url: ApiEndpoints.profiles,
      query: {},
    );
  }

  Future<Response> createPrimaryProfile({
    required String fullName,
    required int age,
    required String gender,
    required String bloodType,
    required List<Map<String, dynamic>> chronicDiseases,
    required List<Map<String, dynamic>> allergies,
    String? imagePath, 
  }) async {
    final formData = FormData.fromMap({
      'full_name': fullName,
      'age': age.toString(),
      'gender': gender,
      'blood_type': bloodType,
      'chronic_diseases': chronicDiseases.toString(),
      'allergies': allergies.toString(),
      if (imagePath != null)
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
    });

    return await DioHelper.postFormData(
      url: ApiEndpoints.primaryProfile,
      data: formData,
    );
  }

  Future<Response> createFamilyProfile({
    required String fullName,
    required int age,
    required String gender,
    required String relationship,
    required String bloodType,
    required List<Map<String, dynamic>> chronicDiseases,
    required List<Map<String, dynamic>> allergies,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      'full_name': fullName,
      'age': age.toString(),
      'gender': gender,
      'relationship': relationship,
      'blood_type': bloodType,
      'chronic_diseases': chronicDiseases.toString(),
      'allergies': allergies.toString(),
      if (imagePath != null)
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
    });

    return await DioHelper.postFormData(
      url: ApiEndpoints.familyProfile,
      data: formData,
    );
  }
}