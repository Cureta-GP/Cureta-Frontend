import 'package:equatable/equatable.dart';
import 'medicine_enums.dart';

class DoseLogModel extends Equatable {
  final String id;
  final String medicineId;
  final DateTime scheduledAt;
  final DoseStatus status;
  final String? notes;
  final DateTime? takenAt;
  final String? remoteId;

  const DoseLogModel({
    required this.id,
    required this.medicineId,
    required this.scheduledAt,
    required this.status,
    this.notes,
    this.takenAt,
    this.remoteId,
  });

  factory DoseLogModel.fromJson(Map<String, dynamic> json) {
    return DoseLogModel(
      id: json['id']?.toString() ?? '',
      medicineId: json['medicine_id']?.toString() ?? '',
      scheduledAt:
          DateTime.tryParse(json['scheduled_at'] as String? ?? '') ??
          DateTime.now(),
      status: DoseStatus.fromJson(json['status'] as String? ?? 'pending'),
      notes: json['notes']?.toString(),
      takenAt: json['taken_at'] != null
          ? DateTime.tryParse(json['taken_at'] as String)
          : null,
      remoteId: json['remote_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicine_id': medicineId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': status.toJson(),
      if (notes != null) 'notes': notes,
      if (takenAt != null) 'taken_at': takenAt!.toIso8601String(),
    };
  }

  DoseLogModel copyWith({
    String? id,
    String? medicineId,
    DateTime? scheduledAt,
    DoseStatus? status,
    String? notes,
    DateTime? takenAt,
    String? remoteId,
  }) {
    return DoseLogModel(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      takenAt: takenAt ?? this.takenAt,
      remoteId: remoteId ?? this.remoteId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    medicineId,
    scheduledAt,
    status,
    notes,
    takenAt,
    remoteId,
  ];
}
