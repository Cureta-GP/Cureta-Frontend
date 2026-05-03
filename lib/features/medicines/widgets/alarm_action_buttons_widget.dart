import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';

/// "Taken" and "Missed" action buttons shown on the alarm screen.
class AlarmActionButtonsWidget extends StatelessWidget {
  const AlarmActionButtonsWidget({
    super.key,
    required this.onTaken,
    required this.onMissed,
  });

  final VoidCallback onTaken;
  final VoidCallback onMissed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final radius = context.radius;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onTaken,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius.full),
              ),
              padding: EdgeInsetsDirectional.symmetric(vertical: spacing.lg),
              elevation: 4,
            ),
            child: Text(
              AppLocalizations.medicinesAlarmTaken,
              style: typography.button.copyWith(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: spacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onMissed,
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.error,
              side: BorderSide(color: colors.error, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius.full),
              ),
              padding: EdgeInsetsDirectional.symmetric(vertical: spacing.lg),
            ),
            child: Text(
              AppLocalizations.medicinesAlarmMissed,
              style: typography.button.copyWith(color: colors.error),
            ),
          ),
        ),
      ],
    );
  }
}
