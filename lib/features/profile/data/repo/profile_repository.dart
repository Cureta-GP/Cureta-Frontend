// lib/data/repositories/profile_repository.dart
import 'package:cureta/features/profile/data/services/profile_service.dart';

import '../models/profile_model.dart';

class ProfileRepository {
  final ProfileService _service;

  ProfileRepository(this._service);

  Future<List<ProfileModel>> getProfiles() async {
    final response = await _service.getProfiles();

    final List data = response.data['data'];

    return data.map((profile) => ProfileModel.fromJson(profile)).toList();
  }

  Future<ProfileModel> createPrimaryProfile({
    required String fullName,
    required int age,
    required String gender,
    required String bloodType,
    required List<Map<String, dynamic>> chronicDiseases,
    required List<Map<String, dynamic>> allergies,
    String? imagePath,
  }) async {
    final response = await _service.createPrimaryProfile(
      fullName: fullName,
      age: age,
      gender: gender,
      bloodType: bloodType,
      chronicDiseases: chronicDiseases,
      allergies: allergies,
      imagePath: imagePath,
    );
    return ProfileModel.fromJson(response.data['data']);
  }

  Future<ProfileModel> createFamilyProfile({
    required String fullName,
    required int age,
    required String gender,
    required String relationship,
    required String bloodType,
    required List<Map<String, dynamic>> chronicDiseases,
    required List<Map<String, dynamic>> allergies,
    String? imagePath,
  }) async {
    final response = await _service.createFamilyProfile(
      fullName: fullName,
      age: age,
      gender: gender,
      relationship: relationship,
      bloodType: bloodType,
      chronicDiseases: chronicDiseases,
      allergies: allergies,
      imagePath: imagePath,
    );
    return ProfileModel.fromJson(response.data['data']);
  }
}
