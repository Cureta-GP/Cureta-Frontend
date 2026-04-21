import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/shared/widgets/add_record_next_button.dart';
import 'package:flutter/material.dart';

/// Bottom action buttons for the record detail screen:
/// reuses [AddRecordNextButton] for "Edit Record" and adds a danger
/// "Delete Record" text button below it.
class RecordDetailsBottomActions extends StatelessWidget {
  const RecordDetailsBottomActions({
    super.key,
    this.isEditing = false,
    this.isBusy = false,
    this.onEdit,
    this.onSave,
    this.onCancel,
    this.onDelete,
  });

  final bool isEditing;
  final bool isBusy;
  final VoidCallback? onEdit;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
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
          AddRecordNextButton(
            label: isEditing
                ? AppLocalizations.addRecordSaveRecord
                : AppLocalizations.recordDetailsEditRecord,
            onPressed: isEditing ? onSave : onEdit,
            isLoading: isBusy,
          ),
          SizedBox(height: spacing.md),
          if (isEditing)
            TextButton(
              onPressed: isBusy ? null : onCancel,
              child: Text(
                AppLocalizations.addRecordCancel,
                style: typography.medicalRecordDetailDeleteBtn.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            )
          else
            TextButton.icon(
              onPressed: isBusy ? null : onDelete,
              icon: Icon(Icons.delete, size: 20, color: colors.error),
              label: Text(
                AppLocalizations.recordDetailsDeleteRecord,
                style: typography.medicalRecordDetailDeleteBtn.copyWith(
                  color: colors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
