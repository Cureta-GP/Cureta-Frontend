import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomActionDialog extends StatelessWidget {
  const CustomActionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.primaryColor,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color primaryColor;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

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
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(radius.xl),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.18),
              width: spacing.hairline,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.12),
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
              // ── Header strip ───────────────────────────────────────
              Container(
                padding: EdgeInsets.symmetric(vertical: spacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor.withValues(alpha: 0.10),
                      primaryColor.withValues(alpha: 0.02),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: spacing.xl + spacing.xxl + spacing.md,
                    height: spacing.xl + spacing.xxl + spacing.md,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withValues(alpha: 0.10),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.22),
                        width: spacing.hairline,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.18),
                          blurRadius: spacing.lg,
                          spreadRadius: spacing.xs,
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: primaryColor,
                      size: spacing.xxl,
                    ),
                  ),
                ),
              ),

              // ── Body ─────────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.xl,
                  spacing.md,
                  spacing.xl,
                  spacing.xl,
                ),
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: typography.medicalRecordScreenTitle.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: typography.medicalRecordHelper.copyWith(
                        color: colors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: spacing.xl),

                    // ── Actions ───────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onCancel,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.textSecondary,
                              side: BorderSide(
                                color: colors.divider,
                                width: spacing.hairline,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: spacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(radius.lg),
                              ),
                            ),
                            child: Text(cancelLabel),
                          ),
                        ),
                        SizedBox(width: spacing.md),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(radius.lg),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.35),
                                  blurRadius: spacing.lg,
                                  offset: Offset(0, spacing.xs),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: colors.background,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  vertical: spacing.md,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(radius.lg),
                                ),
                              ),
                              onPressed: onConfirm,
                              icon: Icon(
                                icon,
                                size: spacing.lg,
                              ),
                              label: Text(confirmLabel),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
