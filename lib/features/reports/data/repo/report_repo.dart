import 'package:cureta/core/error_handling/error_handler.dart';
import '../models/health_report_model.dart';
import '../services/report_service.dart';

class ReportRepo {
  final ReportService _service;

  ReportRepo(this._service);

  /// Generate a new health report
  Future<HealthReportModel> generateReport({
    required String profileId,
    required String timePeriod,
    String language = 'en',
  }) async {
    try {
      final response = await _service.generateReport(
        profileId: profileId,
        timePeriod: timePeriod,
        language: language,
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return HealthReportModel.fromJson(data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  /// Fetch all past reports for a profile
  Future<List<HealthReportModel>> getReportsHistory({
    required String profileId,
  }) async {
    try {
      final response = await _service.getReportsHistory(
        profileId: profileId,
      );
      final list = response.data['data'] as List;
      return list
          .map((e) => HealthReportModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
