import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/user_record_status_pill.dart';
import 'package:flutter/material.dart';

/// Displays the condition name and ongoing status pill at the top of
/// the record details screen.
class RecordDetailsHeader extends StatelessWidget {
  const RecordDetailsHeader({
    super.key,
    required this.conditionName,
    required this.isOngoing,
  });

  final String conditionName;
  final bool isOngoing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Padding(
      padding: EdgeInsets.only(top: spacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            conditionName,
            style: typography.medicalRecordDetailHero.copyWith(
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: spacing.lg),
          UserRecordStatusPill(
            label: AppLocalizations.recordDetailsStatusOngoing,
            isOngoing: isOngoing,
          ),
        ],
      ),
    );
  }
}
