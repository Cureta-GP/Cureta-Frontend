import 'package:cureta/features/home/data/models/schedule_entry.dart';
import 'package:cureta/features/home/data/service/schedule_service.dart';

class ScheduleRepository {
  const ScheduleRepository(this._service);

  final ScheduleService _service;

  Future<List<ScheduleEntry>> getTodaySchedule(String profileId) async {
    final response = await _service.getSchedule(
      profileId: profileId,
      date: _todayDate(),
    );

    if (!response.isSuccess) {
      throw Exception('Server returned status: ${response.status.name}');
    }

    return response.scheduled;
  }

  String _todayDate() => DateTime.now().toIso8601String().substring(0, 10);
}
