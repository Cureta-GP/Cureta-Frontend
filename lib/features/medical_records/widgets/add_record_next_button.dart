import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordNextButton extends StatelessWidget {
  const AddRecordNextButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_forward, size: 20),
        label: Text(
          AppLocalizations.addRecordNext,
          style: typography.medicalRecordButton,
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.full),
          ),
          padding: EdgeInsets.symmetric(vertical: spacing.lg),
        ),
      ),
    );
  }
}
