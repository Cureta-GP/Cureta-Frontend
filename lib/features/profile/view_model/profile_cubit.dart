import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/profile/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({
    required this.repository,
    ProfileState? initialState,
    bool isFamilyMember = false,
  }) : super(
         initialState ?? ProfileState(isAddingFamilyMember: isFamilyMember),
       );

  // 🔹 تحديث الحقول
  void updateName(String val) => emit(state.copyWith(name: val));
  void updateGender(String val) => emit(state.copyWith(gender: val));
  void updateRelation(String val) => emit(state.copyWith(relationship: val));
  void updateAge(int val) => emit(state.copyWith(age: val));
  void updateBloodType(String val) => emit(state.copyWith(bloodType: val));
  void updatePage(int page) => emit(state.copyWith(currentPage: page));

  void updateOtherChronicText(String val) => emit(state.copyWith(otherChronicText: val));
  void updateOtherAllergyText(String val) => emit(state.copyWith(otherAllergyText: val));

  void toggleChronic(String item) {
    final newSet = Set<String>.from(state.chronicConditions);
    newSet.contains(item) ? newSet.remove(item) : newSet.add(item);
    emit(state.copyWith(chronicConditions: newSet));
  }

  void toggleAllergy(String item) {
    final newSet = Set<String>.from(state.allergies);
    if (item == 'no_allergy') {
      newSet.clear();
      newSet.add(item);
    } else {
      newSet.remove('no_allergy');
      newSet.contains(item) ? newSet.remove(item) : newSet.add(item);
    }
    emit(state.copyWith(allergies: newSet));
  }

  void nextStep(PageController controller) {
    int next = state.currentPage + 1;
    if (!state.isAddingFamilyMember && next == 2) next = 3;
    if (next < 7) {
      controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      emit(state.copyWith(currentPage: next));
    }
  }

  void previousStep(PageController controller) {
    int prev = state.currentPage - 1;
    if (!state.isAddingFamilyMember && state.currentPage == 3) {
      prev = 1; // تخطي العلاقة عند الرجوع
    }
    if (prev >= 0) {
      controller.animateToPage(
        prev,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      emit(state.copyWith(currentPage: prev));
    }
  }

  // 🔹 إنشاء البروفايل
  Future<ProfileModel> createProfile({String? imagePath}) async {
    final chronicList = _mapConditions(state.chronicConditions, state.otherChronicText);
    final allergyList = _mapConditions(state.allergies, state.otherAllergyText);

    if (state.isAddingFamilyMember) {
      return await repository.createFamilyProfile(
        fullName: state.name,
        age: state.age,
        gender: state.gender,
        relationship: state.relationship,
        bloodType: state.bloodType,
        chronicDiseases: chronicList,
        allergies: allergyList,
        imagePath: imagePath,
      );
    } else {
      return await repository.createPrimaryProfile(
        fullName: state.name,
        age: state.age,
        gender: state.gender,
        bloodType: state.bloodType,
        chronicDiseases: chronicList,
        allergies: allergyList,
        imagePath: imagePath,
      );
    }
  }

  Future<ProfileModel> updateProfile(
    String profileId, {
    String? imagePath,
    bool removeImage = false,
  }) async {
    final chronicList = _mapConditions(state.chronicConditions, state.otherChronicText);
    final allergyList = _mapConditions(state.allergies, state.otherAllergyText);

    return await repository.updateProfile(
      profileId: profileId,
      fullName: state.name,
      age: state.age,
      gender: state.gender,
      bloodType: state.bloodType,
      chronicDiseases: chronicList,
      allergies: allergyList,
      relationship: state.isAddingFamilyMember ? state.relationship : null,
      imagePath: imagePath,
      removeImage: removeImage,
    );
  }

  List<Map<String, dynamic>> _mapConditions(Set<String> conditions, String otherText) {
    if (conditions.isEmpty) {
      // إرجاع list فارغة إذا لم يكن هناك اختيارات
      return [];
    }

    return conditions
        .where((e) {
          // تخطي 'other' إذا لم يكن هناك نص مخصص
          // تخطي 'no_allergy' إذا كان هناك اختيارات أخرى
          if (e == 'other' && otherText.isEmpty) return false;
          return true;
        })
        .map((e) {
          String value = e;
          if (e == 'other' && otherText.isNotEmpty) {
            value = otherText;
          }
          return {
            'id': 0,
            'description': value,
            'name': value,
          };
        })
        .toList();
  }
}
