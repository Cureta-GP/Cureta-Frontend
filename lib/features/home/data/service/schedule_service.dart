import 'package:cureta/core/Services/dio_helper.dart';
import 'package:cureta/core/constants/api_endpoints.dart';
import 'package:cureta/features/home/data/models/daily_schedule_response.dart';

class ScheduleService {
  const ScheduleService();

  Future<DailyScheduleResponse> getSchedule({
    required String profileId,
    required String date,
  }) async {
    print('>>> profileId: $profileId');
    print('>>> date: $date');
    final response = await DioHelper.getData(
      url: ApiEndpoints.schedule,
      query: {'profile_id': profileId, 'date': date},
    );

    return DailyScheduleResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
