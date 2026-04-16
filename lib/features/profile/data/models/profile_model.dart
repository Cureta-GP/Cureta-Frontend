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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'primary_owner_id': primaryOwnerId,
      'parent_profile_id': parentProfileId,
      'is_primary': isPrimary,
      'full_name': fullName,
      'relationship': relationship,
      'age': age,
      'gender': gender,
      'blood_type': bloodType,
      'image_url': imageUrl,
      'created_at': createdAt,
      'chronic_diseases': chronicDiseases,
      'allergies': allergies,
    };
  }
}
/// Model class for profile data
/*class ProfileModel {
  final String id;
  final String name;
  final String relationship;
  final String? avatarUrl;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.relationship,
    this.avatarUrl,
  });
}*/