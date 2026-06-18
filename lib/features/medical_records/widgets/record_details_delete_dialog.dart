import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

import 'package:cureta/shared/widgets/custom_action_dialog.dart';

/// Shows a confirmation dialog before permanently deleting a medical record.
///
/// Returns `true` if the user confirms, `false` if cancelled, `null` if dismissed.
Future<bool?> showRecordDeleteConfirmationDialog(
  BuildContext context, {
  required String conditionName,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) => _DeleteConfirmDialog(conditionName: conditionName),
  );
}

class _DeleteConfirmDialog extends StatelessWidget {
  const _DeleteConfirmDialog({required this.conditionName});

  final String conditionName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CustomActionDialog(
      title: AppLocalizations.recordDetailsDeleteConfirmTitle,
      message: AppLocalizations.recordDetailsDeleteConfirmMessage(conditionName),
      icon: Icons.delete_forever_rounded,
      primaryColor: colors.error,
      confirmLabel: AppLocalizations.recordDetailsDeleteRecord,
      cancelLabel: AppLocalizations.addRecordCancel,
      onConfirm: () => Navigator.of(context).pop(true),
      onCancel: () => Navigator.of(context).pop(false),
    );
  }
}
