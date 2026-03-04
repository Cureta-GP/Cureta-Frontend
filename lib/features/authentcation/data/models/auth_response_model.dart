import 'user_model.dart';

class AuthResponseModel {
  final String status;
  final UserModel? data;
  final String? message; // populated on error responses

  const AuthResponseModel({required this.status, this.data, this.message});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      status: json['status'] as String,
      data: json['data'] != null
          ? UserModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }

  bool get isSuccess => status.toUpperCase() == 'SUCCESS' && data != null;
}
