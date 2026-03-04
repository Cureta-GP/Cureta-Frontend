import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordNotesCard extends StatelessWidget {
  const AddRecordNotesCard({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.xl),
      ),
      padding: EdgeInsets.all(spacing.xl),
      child: TextField(
        controller: controller,
        maxLines: 8,
        minLines: 8,
        style: typography.medicalRecordInput.copyWith(
          color: colors.textPrimary,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: AppLocalizations.addRecordOptionalNotesHint,
          hintStyle: typography.medicalRecordInput.copyWith(
            color: colors.textHint,
          ),
        ),
      ),
    );
  }
}
