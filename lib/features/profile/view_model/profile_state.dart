// profile_cubit.dart

import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String gender;
  final String relationship;
  final int age;
  final String bloodType;
  final Set<String> chronicConditions;
  final Set<String> allergies;
  final String otherChronicText;
  final String otherAllergyText;
  final int currentPage;
  final bool isAddingFamilyMember; 

  const ProfileState({
    this.name = '',
    this.gender = '',
    this.relationship = '',
    this.age = 25,
    this.bloodType = '',
    this.chronicConditions = const {},
    this.allergies = const {},
    this.otherChronicText = '',
    this.otherAllergyText = '',
    this.currentPage = 0,
    required this.isAddingFamilyMember,
  });

  ProfileState copyWith({
    String? name, String? gender, String? relationship,
    int? age, String? bloodType, Set<String>? chronicConditions,
    Set<String>? allergies, String? otherChronicText, String? otherAllergyText,
    int? currentPage, bool? isAddingFamilyMember,
  }) {
    return ProfileState(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      relationship: relationship ?? this.relationship,
      age: age ?? this.age,
      bloodType: bloodType ?? this.bloodType,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      allergies: allergies ?? this.allergies,
      otherChronicText: otherChronicText ?? this.otherChronicText,
      otherAllergyText: otherAllergyText ?? this.otherAllergyText,
      currentPage: currentPage ?? this.currentPage,
      isAddingFamilyMember: isAddingFamilyMember ?? this.isAddingFamilyMember,
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "gender": gender,
    "relationship": isAddingFamilyMember ? relationship : "Self",
    "age": age,
    "blood_type": bloodType,
    "chronic_conditions": chronicConditions.toList(),
    "allergies": allergies.toList(),
  };

  @override
  List<Object?> get props => [
    name,
    gender,
    relationship,
    age,
    bloodType,
    chronicConditions,
    allergies,
    currentPage,
    isAddingFamilyMember,
  ];
}
