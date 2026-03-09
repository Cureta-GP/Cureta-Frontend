// lib/data/repositories/profile_repository.dart
import 'package:cureta/features/profile/data/services/profile_service.dart';

import '../models/profile_model.dart';

class ProfileRepository {
  final ProfileService _service;

  ProfileRepository(this._service);

  String _normalizeGenderForApi(String gender) {
    final value = gender.trim().toLowerCase();

    // Backend accepts only: Male, Female
    if (value == 'male' || value == 'm' || value == 'ذكر') return 'Male';
    if (value == 'female' || value == 'f' || value == 'انثى' || value == 'أنثى') {
      return 'Female';
    }

    // Fall back to original value to surface backend validation for unknown inputs.
    return gender;
  }
  String _normalizeRelationshipForApi(String relationship) {
    final value = relationship.trim().toLowerCase();

    // Backend accepts only: Father, Mother, Brother, Sister, Son, Daughter
    if (value == 'father' || value == 'dad' || value == 'أب') return 'Father';
    if (value == 'mother' || value == 'mom' || value == 'أم') return 'Mother';
    if (value == 'brother' || value == 'bro' || value == 'أخ') return 'Brother';
    if (value == 'sister' || value == 'sis' || value == 'أخت') return 'Sister';
    if (value == 'son' || value == 'ابن') return 'Son';
    if (value == 'daughter' || value == 'ابنة') return 'Daughter';

    // Fall back to original value to surface backend validation for unknown inputs.
    return relationship;
  }

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
    final normalizedGender = _normalizeGenderForApi(gender);

    final response = await _service.createPrimaryProfile(
      fullName: fullName,
      age: age,
      gender: normalizedGender,
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
    final normalizedGender = _normalizeGenderForApi(gender);

    final response = await _service.createFamilyProfile(
      fullName: fullName,
      age: age,
      gender: normalizedGender,
      relationship: _normalizeRelationshipForApi(relationship),
      bloodType: bloodType,
      chronicDiseases: chronicDiseases,
      allergies: allergies,
      imagePath: imagePath,
    );
    return ProfileModel.fromJson(response.data['data']);
  }
}
