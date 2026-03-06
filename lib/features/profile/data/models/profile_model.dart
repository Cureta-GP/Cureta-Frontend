// lib/data/models/profile_model.dart
class ProfileModel {
  final String id;
  final int primaryOwnerId;
  final String? parentProfileId;
  final bool isPrimary;
  final String fullName;
  final String relationship;
  final int age;
  final String gender;
  final String bloodType;
  final String? imageUrl;
  final String createdAt;
  final List<dynamic> chronicDiseases;
  final List<dynamic> allergies;

  ProfileModel({
    required this.id,
    required this.primaryOwnerId,
    this.parentProfileId,
    required this.isPrimary,
    required this.fullName,
    required this.relationship,
    required this.age,
    required this.gender,
    required this.bloodType,
    this.imageUrl,
    required this.createdAt,
    required this.chronicDiseases,
    required this.allergies,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'],
        primaryOwnerId: json['primary_owner_id'],
        parentProfileId: json['parent_profile_id'],
        isPrimary: json['is_primary'],
        fullName: json['full_name'],
        relationship: json['relationship'],
        age: json['age'],
        gender: json['gender'],
        bloodType: json['blood_type'],
        imageUrl: json['image_url'],
        createdAt: json['created_at'],
        chronicDiseases: json['chronic_diseases'] ?? [],
        allergies: json['allergies'] ?? [],
      );
}