import 'profile_model.dart';

class ProfilesResponseModel {
  final String status;
  final List<ProfileModel> data;

  ProfilesResponseModel({
    required this.status,
    required this.data,
  });

  factory ProfilesResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfilesResponseModel(
      status: json['status'],
      data: (json['data'] as List)
          .map((profile) => ProfileModel.fromJson(profile))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((profile) => profile.toJson()).toList(),
    };
  }
}