import 'package:dio/dio.dart';
import 'package:cureta/core/Services/dio_helper.dart';

class ReportService {
  /// POST /api/reports/generate
  Future<Response> generateReport({
    required String profileId,
    required String timePeriod,
    String language = 'en',
  }) async {
    return await DioHelper.postData(
      url: 'reports/generate',
      data: {
        'profile_id': profileId,
        'time_period': timePeriod,
        'language': language,
      },
    );
  }

  /// GET /api/reports/:profileId
  Future<Response> getReportsHistory({
    required String profileId,
  }) async {
    return await DioHelper.getData(
      url: 'reports/$profileId',
      query: {},
    );
  }
}
