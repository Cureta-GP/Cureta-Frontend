import 'package:cureta/features/home/data/models/schedule_entry.dart';

/// Matches ApiStatus enum: success | fail | error
enum ApiStatus {
  success,
  fail,
  error;

  static ApiStatus fromRaw(String value) => ApiStatus.values.firstWhere(
    (e) => e.name == value.toLowerCase(),
    orElse: () => ApiStatus.error,
  );
}

/// Matches DailyScheduleResponse schema:
/// { status, data: { scheduled: [...] } }
class DailyScheduleResponse {
  const DailyScheduleResponse({required this.status, required this.scheduled});

  final ApiStatus status;
  final List<ScheduleEntry> scheduled;

  bool get isSuccess => status == ApiStatus.success;

  factory DailyScheduleResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final list = data['scheduled'] as List<dynamic>;

    return DailyScheduleResponse(
      status: ApiStatus.fromRaw(json['status'] as String),
      scheduled:
          list
              .map((e) => ScheduleEntry.fromJson(e as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt)),
    );
  }
}
