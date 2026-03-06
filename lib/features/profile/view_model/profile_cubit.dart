import 'package:cureta/features/profile/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  
  ProfileCubit({required bool isFamilyMember})
    : super(ProfileState(isAddingFamilyMember: isFamilyMember));

  void updateName(String val) => emit(state.copyWith(name: val));
  void updateGender(String val) => emit(state.copyWith(gender: val));
  void updateRelation(String val) => emit(state.copyWith(relationship: val));
  void updateAge(int val) => emit(state.copyWith(age: val));
  void updateBloodType(String val) => emit(state.copyWith(bloodType: val));
  void updatePage(int page) => emit(state.copyWith(currentPage: page));

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
    if (!state.isAddingFamilyMember && state.currentPage == 3)
      prev = 1; // تخطي العلاقة عند الرجوع
    if (prev >= 0) {
      controller.animateToPage(
        prev,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      emit(state.copyWith(currentPage: prev));
    }
  }
}
