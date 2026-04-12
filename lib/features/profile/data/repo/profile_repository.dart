// lib/data/repositories/profile_repository.dart
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:cureta/features/profile/data/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile_model.dart';

class ProfileRepository {
  static const String _profileIdKey = 'profileId';
  final ProfileService _service;

  ProfileRepository(this._service);

  String _normalizeGenderForApi(String gender) {
    final value = gender.trim().toLowerCase();

    // Backend accepts only: Male, Female
    if (value == 'male' || value == 'm' || value == 'ذكر') return 'Male';
    if (value == 'female' ||
        value == 'f' ||
        value == 'انثى' ||
        value == 'أنثى') {
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
    final profiles = data
        .map((profile) => ProfileModel.fromJson(profile))
        .toList();

    if (profiles.isNotEmpty) {
      final selected = profiles.firstWhere(
        (p) => p.isPrimary,
        orElse: () => profiles.first,
      );
      await cacheSelectedProfileId(selected.id);
    }

    return profiles;
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

    try {
      final response = await _service.createPrimaryProfile(
        fullName: fullName,
        age: age,
        gender: normalizedGender,
        bloodType: bloodType,
        chronicDiseases: chronicDiseases,
        allergies: allergies,
        imagePath: imagePath,
      );
      final profile = ProfileModel.fromJson(response.data['data']);
      await cacheSelectedProfileId(profile.id);
      return profile;
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final code = responseData is Map
          ? responseData['code']?.toString().toUpperCase()
          : null;

      if (code == 'PROFILE_ALREADY_EXISTS' && responseData is Map) {
        final payload = responseData['data'];
        final profileId =
            responseData['profile_id']?.toString() ??
            (payload is Map ? payload['id']?.toString() : null);

        if (profileId != null && profileId.isNotEmpty) {
          await cacheSelectedProfileId(profileId);
        }

        if (payload is Map) {
          return ProfileModel.fromJson(Map<String, dynamic>.from(payload));
        }

        final profiles = await getProfiles();
        if (profiles.isNotEmpty) {
          if (profileId != null) {
            final exact = profiles.where((p) => p.id == profileId);
            if (exact.isNotEmpty) {
              return exact.first;
            }
          }
          return profiles.firstWhere(
            (p) => p.isPrimary,
            orElse: () => profiles.first,
          );
        }
      }

      throw ErrorHandler.handle(e);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
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
    final profile = ProfileModel.fromJson(response.data['data']);
    await cacheSelectedProfileId(profile.id);
    return profile;
  }

  Future<void> cacheSelectedProfileId(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileIdKey, profileId);
  }

  Future<String?> getCachedProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileIdKey);
  }

  Future<void> clearCachedProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileIdKey);
  }

  /// Returns the currently selected profile id.
  ///
  /// Priority:
  /// 1) cached selection
  /// 2) first primary profile from backend
  /// 3) first profile from backend
  ///
  /// Returns null only when there are no profiles.
  Future<String?> getResolvedSelectedProfileId() async {
    final cachedId = await getCachedProfileId();
    if (cachedId != null && cachedId.isNotEmpty) {
      return cachedId;
    }

    final profiles = await getProfiles();
    if (profiles.isEmpty) return null;

    final selected = profiles.firstWhere(
      (p) => p.isPrimary,
      orElse: () => profiles.first,
    );
    await cacheSelectedProfileId(selected.id);
    return selected.id;
  }

  Future<bool> hasProfiles() async {
    final cachedId = await getCachedProfileId();
    if (cachedId != null && cachedId.isNotEmpty) {
      return true;
    }

    try {
      final profiles = await getProfiles();
      return profiles.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
