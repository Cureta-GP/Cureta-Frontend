// lib/data/services/profile_service.dart
import 'dart:convert';

import 'package:cureta/core/Services/dio_helper.dart';
import 'package:cureta/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart';

class ProfileService {
  Future<Response> getProfiles() async {
    return await DioHelper.getData(
      url: ApiEndpoints.profiles, query: {}, 
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
    final formData = {
      'full_name': fullName,
      'age': age,
      'gender': gender,
      'blood_type': bloodType,
      'chronic_diseases': chronicDiseases,
      'allergies': allergies,
    };

    if (imagePath != null) {
      final Map<String, dynamic> map = Map.from(formData);
      map['chronic_diseases'] = jsonEncode(chronicDiseases);
      map['allergies'] = jsonEncode(allergies);
      map['image'] = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );

      return await DioHelper.postFormData(
        url: ApiEndpoints.primaryProfile,
        data: FormData.fromMap(map),
      );
    } else {
      return await DioHelper.postData(
        url: ApiEndpoints.primaryProfile,
        data: formData,
      );
    }
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
    final formData = {
      'full_name': fullName,
      'age': age,
      'gender': gender,
      'relationship': relationship,
      'blood_type': bloodType,
      'chronic_diseases': chronicDiseases,
      'allergies': allergies,
    };

    if (imagePath != null) {
      final Map<String, dynamic> map = Map.from(formData);
      map['chronic_diseases'] = jsonEncode(chronicDiseases);
      map['allergies'] = jsonEncode(allergies);
      map['image'] = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );

      return await DioHelper.postFormData(
        url: ApiEndpoints.familyProfile,
        data: FormData.fromMap(map),
      );
    } else {
      return await DioHelper.postData(
        url: ApiEndpoints.familyProfile,
        data: formData,
      );
    }
  }

  Future<Response> updateProfile({
    required String profileId,
    required String fullName,
    required int age,
    required String gender,
    required String bloodType,
    required List<Map<String, dynamic>> chronicDiseases,
    required List<Map<String, dynamic>> allergies,
    String? relationship,
    String? imagePath,
    bool removeImage = false,
  }) async {
    final formData = {
      'full_name': fullName,
      'age': age,
      'gender': gender,
      'blood_type': bloodType,
      'chronic_diseases': chronicDiseases,
      'allergies': allergies,
      if (relationship != null) 'relationship': relationship,
      if (removeImage) 'remove_image': true,
    };

    if (imagePath != null || removeImage) {
      final Map<String, dynamic> map = Map.from(formData);
      map['chronic_diseases'] = jsonEncode(chronicDiseases);
      map['allergies'] = jsonEncode(allergies);
      if (imagePath != null) {
        map['image'] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
      }

      return await DioHelper.putData(
        url: ApiEndpoints.profileData(profileId),
        data: FormData.fromMap(map),
      );
    }

    return await DioHelper.putData(
      url: ApiEndpoints.profileData(profileId),
      data: formData,
    );
  }

  Future<Response> deleteProfile({
    required String profileId,
  }) async {
    return await DioHelper.deleteData(
      url: ApiEndpoints.profileData(profileId),
    );
  }
}