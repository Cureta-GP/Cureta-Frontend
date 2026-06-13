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
  final String? createdAt;
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
    this.createdAt,
    required this.chronicDiseases,
    required this.allergies,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      primaryOwnerId: json['primary_owner_id'] is int
          ? json['primary_owner_id']
          : int.tryParse(json['primary_owner_id']?.toString() ?? '') ?? 0,
      parentProfileId: json['parent_profile_id']?.toString(),
      isPrimary: json['is_primary'] ?? false,
      fullName: json['full_name']?.toString() ?? '',
      relationship: json['relationship']?.toString() ?? 'Self',
      age: json['age'] is int
          ? json['age']
          : int.tryParse(json['age']?.toString() ?? '') ?? 0,
      gender: json['gender']?.toString() ?? '',
      bloodType: json['blood_type']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      createdAt: json['created_at']?.toString(),
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
      if (createdAt != null) 'created_at': createdAt,
      'chronic_diseases': chronicDiseases,
      'allergies': allergies,
    };
  }

  void operator [](String other) {}
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