/// Model class for profile data
class ProfileModel {
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
}