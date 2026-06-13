import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/health_report_model.dart';
import '../widgets/report_section_header_widget.dart';
import '../widgets/report_patient_header_widget.dart';
import '../widgets/report_adherence_card_widget.dart';
import '../widgets/report_ai_insights_card_widget.dart';
import '../widgets/report_top_conditions_widget.dart';
import '../widgets/report_medications_timeline_widget.dart';

class ReportDetailsView extends StatelessWidget {
  const ReportDetailsView({super.key, required this.report});

  final HealthReportModel report;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'reports.report_details'.tr(),
          style: typography.medicalRecordScreenTitle.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: spacing.xl,
            vertical: spacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReportPatientHeaderWidget(patient: report.patientInfo),
              SizedBox(height: spacing.xl),

              ReportSectionHeaderWidget(
                titleKey: 'reports.adherence_summary',
                icon: Icons.medication_outlined,
              ),
              SizedBox(height: spacing.md),
              ReportAdherenceCardWidget(adherence: report.adherenceSummary),
              SizedBox(height: spacing.xl),

              ReportSectionHeaderWidget(
                titleKey: 'reports.ai_insights',
                icon: Icons.auto_awesome_outlined,
              ),
              SizedBox(height: spacing.md),
              ReportAiInsightsCardWidget(insights: report.aiInsights),
              SizedBox(height: spacing.xl),

              if (report.topConditions.isNotEmpty) ...[
                ReportSectionHeaderWidget(
                  titleKey: 'reports.top_conditions',
                  icon: Icons.local_hospital_outlined,
                ),
                SizedBox(height: spacing.md),
                ReportTopConditionsWidget(conditions: report.topConditions),
                SizedBox(height: spacing.xl),
              ],

              if (report.medicationsTimeline.isNotEmpty) ...[
                ReportSectionHeaderWidget(
                  titleKey: 'reports.medications_timeline',
                  icon: Icons.schedule_outlined,
                ),
                SizedBox(height: spacing.md),
                ReportMedicationsTimelineWidget(
                  medications: report.medicationsTimeline,
                ),
              ],

              SizedBox(height: spacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
