import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

Future<bool?> showMedicineDeleteConfirmationDialog(
  BuildContext context, {
  required String medicineName,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) => _MedicineDeleteConfirmDialog(medicineName: medicineName),
  );
}

class _MedicineDeleteConfirmDialog extends StatelessWidget {
  const _MedicineDeleteConfirmDialog({required this.medicineName});

  final String medicineName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: spacing.lg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius.xl),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(radius.xl),
            border: Border.all(
              color: colors.error.withValues(alpha: 0.18),
              width: spacing.hairline,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.error.withValues(alpha: 0.12),
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
              Container(
                padding: EdgeInsets.symmetric(vertical: spacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.error.withValues(alpha: 0.10),
                      colors.error.withValues(alpha: 0.02),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: spacing.xl + spacing.xxl + spacing.md,
                    height: spacing.xl + spacing.xxl + spacing.md,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.error.withValues(alpha: 0.10),
                      border: Border.all(
                        color: colors.error.withValues(alpha: 0.22),
                        width: spacing.hairline,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.error.withValues(alpha: 0.18),
                          blurRadius: spacing.lg,
                          spreadRadius: spacing.xs,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.delete_forever_rounded,
                      color: colors.error,
                      size: spacing.xxl,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.lg,
                  spacing.md,
                  spacing.lg,
                  spacing.lg,
                ),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.medicinesDeleteConfirmTitle,
                      textAlign: TextAlign.center,
                      style: typography.medicalRecordScreenTitle.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                    Text(
                      AppLocalizations.medicinesDeleteConfirmMessage(medicineName),
                      textAlign: TextAlign.center,
                      style: typography.medicalRecordHelper.copyWith(
                        color: colors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: spacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.textSecondary,
                              side: BorderSide(
                                color: colors.divider,
                                width: spacing.hairline,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: spacing.xs,
                                vertical: spacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(radius.lg),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.medicinesCancel,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(width: spacing.sm),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(radius.lg),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.error.withValues(alpha: 0.35),
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
                                padding: EdgeInsets.symmetric(
                                  horizontal: spacing.xs,
                                  vertical: spacing.md,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(radius.lg),
                                ),
                              ),
                              onPressed: () =>
                                  Navigator.of(context).pop(true),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_forever_rounded,
                                    size: 20,
                                  ),
                                  SizedBox(width: spacing.xs),
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        AppLocalizations.medicinesDeleteMedicine,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
