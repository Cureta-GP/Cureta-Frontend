import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:flutter/material.dart';

/// Bottom action buttons for the record detail screen:
/// reuses [AddRecordNextButton] for "Edit Record" and adds a danger
/// "Delete Record" text button below it.
class RecordDetailsBottomActions extends StatelessWidget {
  const RecordDetailsBottomActions({super.key, this.onEdit, this.onDelete});

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Padding(
      padding: EdgeInsets.only(top: spacing.xxl),
      child: Column(
        children: [
          // Edit Record — reuses the existing AddRecordNextButton
          AddRecordNextButton(
            label: AppLocalizations.recordDetailsEditRecord,
            onPressed: onEdit,
          ),
          SizedBox(height: spacing.md),
          // Delete Record
          TextButton.icon(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete,
              size: 20,
              color: colors.medicalRecordDetailDanger,
            ),
            label: Text(
              AppLocalizations.recordDetailsDeleteRecord,
              style: typography.medicalRecordDetailDeleteBtn.copyWith(
                color: colors.medicalRecordDetailDanger,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
