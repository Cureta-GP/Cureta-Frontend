import 'medical_record_model.dart';

class CreateRecordResponseModel {
  final String status;
  final MedicalRecordModel? data;
  final String? message;

  const CreateRecordResponseModel({
    required this.status,
    this.data,
    this.message,
  });

  factory CreateRecordResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateRecordResponseModel(
      status: json['status'] as String,
      data: json['data'] != null
          ? MedicalRecordModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }

  bool get isSuccess => status == 'SUCCESS' && data != null;
}
