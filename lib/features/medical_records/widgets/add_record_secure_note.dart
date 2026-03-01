import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordSecureNote extends StatelessWidget {
  const AddRecordSecureNote({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final iconSize = spacing.md + spacing.hairline;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock, size: iconSize, color: colors.textSecondary),
        SizedBox(width: spacing.xs),
        Flexible(
          child: Text(
            AppLocalizations.addRecordDataSecureNote,
            textAlign: TextAlign.center,
            style: typography.medicalRecordSecureNote.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
