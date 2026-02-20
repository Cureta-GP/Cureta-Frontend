import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordTopBar extends StatelessWidget {
  const AddRecordTopBar({super.key, this.onBack, this.onCancel});

  final VoidCallback? onBack;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.lg,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            style: IconButton.styleFrom(
              minimumSize: const Size(40, 40),
              shape: const CircleBorder(),
            ),
            icon: Icon(Icons.arrow_back_ios_new, color: colors.icon, size: 22),
          ),
          const Spacer(),
          TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).maybePop(),
            child: Text(
              AppLocalizations.addRecordCancel,
              style: typography.medicalRecordCancel.copyWith(
                color: colors.medicalRecordMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
