import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Shows a premium-styled duplicate medicine warning dialog.
///
/// [duplicateNames] can be provided for the OCR flow to list multiple
/// medicines that were skipped. If null/empty, shows a generic single-medicine
/// duplicate message (used for the normal add flow).
Future<void> showDuplicateMedicineDialog(
  BuildContext context, {
  List<String>? duplicateNames,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: false,
    builder: (_) => _DuplicateMedicineDialog(duplicateNames: duplicateNames),
  );
}

class _DuplicateMedicineDialog extends StatelessWidget {
  const _DuplicateMedicineDialog({this.duplicateNames});

  final List<String>? duplicateNames;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: spacing.xl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius.xl),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.75,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(radius.xl),
            border: Border.all(
              color: colors.error.withValues(alpha: 0.45),
              width: spacing.hairline,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.error.withValues(alpha: 0.18),
                blurRadius: spacing.xl,
                spreadRadius: spacing.xs,
                offset: Offset(0, spacing.sm),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DialogHeader(colors: colors, spacing: spacing),
              _DialogBody(
                duplicateNames: duplicateNames,
                colors: colors,
                spacing: spacing,
                radius: radius,
                typography: typography,
              ),
              _DialogFooter(
                colors: colors,
                spacing: spacing,
                radius: radius,
                typography: typography,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Red/error gradient header with copy icon.
class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.colors,
    required this.spacing,
  });

  final dynamic colors;
  final dynamic spacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: context.spacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.colors.error.withValues(alpha: 0.30),
            context.colors.error.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: context.spacing.xl +
              context.spacing.xxl +
              context.spacing.md,
          height: context.spacing.xl +
              context.spacing.xxl +
              context.spacing.md,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.error.withValues(alpha: 0.25),
            border: Border.all(
              color: context.colors.error.withValues(alpha: 0.45),
              width: context.spacing.hairline,
            ),
            boxShadow: [
              BoxShadow(
                color: context.colors.error.withValues(alpha: 0.25),
                blurRadius: context.spacing.lg,
                spreadRadius: context.spacing.xs,
              ),
            ],
          ),
          child: Icon(
            Icons.content_copy_rounded,
            color: context.colors.error,
            size: context.spacing.xxl,
          ),
        ),
      ),
    );
  }
}

/// Scrollable body: title, subtitle, and (optional) duplicate names list.
class _DialogBody extends StatelessWidget {
  const _DialogBody({
    this.duplicateNames,
    required this.colors,
    required this.spacing,
    required this.radius,
    required this.typography,
  });

  final List<String>? duplicateNames;
  final dynamic colors;
  final dynamic spacing;
  final dynamic radius;
  final dynamic typography;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    final isMultiple = duplicateNames != null && duplicateNames!.isNotEmpty;

    return Flexible(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          spacing.xl,
          spacing.md,
          spacing.xl,
          0,
        ),
        child: Column(
          children: [
            Text(
              AppLocalizations.duplicateMedicineTitle,
              textAlign: TextAlign.center,
              style: typography.medicalRecordScreenTitle.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: spacing.sm),
            Text(
              isMultiple
                  ? AppLocalizations.duplicateMedicinesOcrSubtitle
                  : AppLocalizations.duplicateMedicineSubtitle,
              textAlign: TextAlign.center,
              style: typography.medicalRecordHelper.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: spacing.lg),
            if (isMultiple)
              ...duplicateNames!.map(
                (name) => Container(
                  margin: EdgeInsets.only(bottom: spacing.sm),
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    color: colors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(radius.md),
                    border: Border.all(
                      color: colors.error.withValues(alpha: 0.20),
                      width: spacing.hairline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.medication_liquid_rounded,
                        color: colors.error.withValues(alpha: 0.8),
                        size: spacing.xl,
                      ),
                      SizedBox(width: spacing.md),
                      Expanded(
                        child: Text(
                          name,
                          style: typography.body.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// "Got It" dismiss button.
class _DialogFooter extends StatelessWidget {
  const _DialogFooter({
    required this.colors,
    required this.spacing,
    required this.radius,
    required this.typography,
  });

  final dynamic colors;
  final dynamic spacing;
  final dynamic radius;
  final dynamic typography;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.xl,
        spacing.md,
        spacing.xl,
        spacing.xl,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius.lg),
          boxShadow: [
            BoxShadow(
              color: colors.error.withValues(alpha: 0.30),
              blurRadius: spacing.lg,
              offset: Offset(0, spacing.xs),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.background,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: spacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.lg),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.duplicateMedicineDismiss,
            style: context.typography.button.copyWith(
              color: colors.background,
            ),
          ),
        ),
      ),
    );
  }
}
