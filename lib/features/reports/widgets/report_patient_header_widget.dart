import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import '../data/models/patient_info_model.dart';

class ReportPatientHeaderWidget extends StatelessWidget {
  const ReportPatientHeaderWidget({super.key, required this.patient});

  final PatientInfoModel patient;

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
        children: [
          CircleAvatar(
            radius: spacing.xxl,
            backgroundColor: colors.accentCyan,
            child: Icon(Icons.person, color: colors.primary, size: spacing.xl),
          ),
          SizedBox(height: spacing.md),
          Text(
            patient.name,
            style: typography.title.copyWith(color: colors.textPrimary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.xs),
          Text(
            '${'reports.age_label'.tr()}: ${patient.age}',
            style: typography.body.copyWith(color: colors.textSecondary),
          ),
          if (patient.bloodType != null && patient.bloodType!.isNotEmpty) ...[
            SizedBox(height: spacing.sm),
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
                patient.bloodType!,
                style: typography.label.copyWith(color: colors.textPrimary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
