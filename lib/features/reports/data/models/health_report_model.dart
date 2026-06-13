import 'patient_info_model.dart';
import 'adherence_summary_model.dart';
import 'top_condition_model.dart';
import 'medication_timeline_model.dart';
import 'ai_insights_model.dart';

class HealthReportModel {
  final String? id;                // null on generate, present on history
  final String? profileId;         // null on generate, present on history
  final String? timePeriod;        // null on generate, present on history
  final PatientInfoModel patientInfo;
  final AdherenceSummaryModel adherenceSummary;
  final List<TopConditionModel> topConditions;
  final List<MedicationTimelineModel> medicationsTimeline;
  final AiInsightsModel aiInsights;
  final DateTime? createdAt;       // null on generate, present on history

  const HealthReportModel({
    this.id,
    this.profileId,
    this.timePeriod,
    required this.patientInfo,
    required this.adherenceSummary,
    required this.topConditions,
    required this.medicationsTimeline,
    required this.aiInsights,
    this.createdAt,
  });

  factory HealthReportModel.fromJson(Map<String, dynamic> json) {
    return HealthReportModel(
      id: json['id'] as String?,
      profileId: json['profile_id'] as String?,
      timePeriod: json['time_period'] as String?,
      patientInfo: PatientInfoModel.fromJson(
        json['patient_info'] as Map<String, dynamic>,
      ),
      adherenceSummary: AdherenceSummaryModel.fromJson(
        json['adherence_summary'] as Map<String, dynamic>,
      ),
      topConditions: (json['top_conditions'] as List)
          .map((e) => TopConditionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      medicationsTimeline: (json['medications_timeline'] as List)
          .map((e) =>
              MedicationTimelineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiInsights: AiInsightsModel.fromJson(
        json['ai_insights'] as Map<String, dynamic>,
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}
