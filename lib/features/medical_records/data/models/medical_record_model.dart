import 'attachment_model.dart';

class MedicalRecordModel {
  final String id;
  final String profileId;
  final String diseaseName;
  final String? notes;
  final String recordDate;
  final DateTime createdAt;
  final List<AttachmentModel> attachments;

  const MedicalRecordModel({
    required this.id,
    required this.profileId,
    required this.diseaseName,
    this.notes,
    required this.recordDate,
    required this.createdAt,
    required this.attachments,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      diseaseName: json['disease_name'] as String,
      notes: json['notes'] as String?,
      recordDate: json['record_date'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'profile_id': profileId,
    'disease_name': diseaseName,
    'notes': notes,
    'record_date': recordDate,
    'created_at': createdAt.toIso8601String(),
    'attachments': attachments.map((a) => a.toJson()).toList(),
  };
}
