import 'package:flutter/material.dart';

import 'package:cureta/core/theme/theme_extensions.dart';

class CuretaPatientCard extends StatelessWidget {
  const CuretaPatientCard({
    super.key,
    required this.patientName,
    required this.lastVisit,
    required this.onViewPressed,
  });

  final String patientName;
  final String lastVisit;
  final VoidCallback onViewPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final radius = context.radius;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.md),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            patientName,
            style: typography.title.copyWith(color: colors.textPrimary),
          ),
          SizedBox(height: spacing.sm),
          Text(
            'Last visit: $lastVisit',
            style: typography.body.copyWith(color: colors.textSecondary),
          ),
          SizedBox(height: spacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius.md),
                ),
              ),
              child: Text('View Profile', style: typography.button),
            ),
          ),
        ],
      ),
    );
  }
}
