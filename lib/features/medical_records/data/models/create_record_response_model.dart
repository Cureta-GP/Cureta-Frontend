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
    String? parsedMessage = json['message'] as String?;
    if (parsedMessage == null && json['data'] is String) {
      parsedMessage = json['data'] as String;
    }

    return CreateRecordResponseModel(
      status: json['status'] as String? ?? 'FAILED',
      data: json['data'] is Map<String, dynamic>
          ? MedicalRecordModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: parsedMessage,
    );
  }

  bool get isSuccess => status == 'SUCCESS' || status == 'success';
}
