import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/patient_info_model.dart';
import 'report_status_badge_widget.dart';

class ReportPatientHeaderWidget extends StatelessWidget {
  const ReportPatientHeaderWidget({
    super.key,
    required this.patient,
    this.status,
  });

  final PatientInfoModel patient;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.xl),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(radius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: spacing.xxl,
                backgroundColor: colors.accentCyan,
                child: Icon(
                  Icons.person,
                  color: colors.primary,
                  size: spacing.xl,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: typography.title.copyWith(
                        color: colors.textPrimary,
                        fontSize: (typography.title.fontSize ?? 24) - 2,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      '${'reports.age_label'.tr()}: ${patient.age}',
                      style: typography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if ((status != null && status!.isNotEmpty) ||
              (patient.bloodType != null && patient.bloodType!.isNotEmpty)) ...[
            SizedBox(height: spacing.md),
            Wrap(
              spacing: spacing.sm,
              runSpacing: spacing.sm,
              children: [
                if (status != null && status!.isNotEmpty)
                  ReportStatusBadgeWidget(status: status!),
                if (patient.bloodType != null && patient.bloodType!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.md,
                      vertical: spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: colors.accentOrange,
                      borderRadius: BorderRadius.circular(radius.full),
                    ),
                    child: Text(
                      '${'reports.blood_type'.tr()}: ${patient.bloodType!}',
                      style: typography.label.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
