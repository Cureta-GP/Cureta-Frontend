import 'package:equatable/equatable.dart';

/// Matches backend enum: PENDING | TAKEN | MISSED
enum DoseStatus {
  pending('PENDING'),
  taken('TAKEN'),
  missed('MISSED');

  const DoseStatus(this.raw);
  final String raw;

  static DoseStatus fromRaw(String value) => DoseStatus.values.firstWhere(
    (e) => e.raw == value.toUpperCase(),
    orElse: () => DoseStatus.pending,
  );
}

/// Matches DailyScheduleItem schema exactly.
class ScheduleEntry extends Equatable {
  const ScheduleEntry({
    required this.medicineId,
    required this.name,
    required this.scheduledAt,
    required this.status,
  });

  final String medicineId; // medicine_id (uuid)
  final String name; // name
  final DateTime scheduledAt; // scheduled_at (date-time)
  final DoseStatus status; // status: PENDING | TAKEN | MISSED

  factory ScheduleEntry.fromJson(Map<String, dynamic> json) {
    return ScheduleEntry(
      medicineId: json['medicine_id'] as String,
      name: json['name'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      status: DoseStatus.fromRaw(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'name': name,
    'scheduled_at': scheduledAt.toIso8601String(),
    'status': status.raw,
  };

  @override
  List<Object?> get props => [medicineId, scheduledAt];
}
