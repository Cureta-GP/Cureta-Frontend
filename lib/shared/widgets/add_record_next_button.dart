import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AddRecordNextButton extends StatelessWidget {
  const AddRecordNextButton({
    super.key,
    this.onPressed,
    this.label,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String? label;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final radius = context.radius;
    final colors = context.colors;
    final typography = context.typography;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: ElevatedButton(
          onPressed: isLoading ? null : (onPressed ?? () {}),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            disabledBackgroundColor: colors.primary,
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.full),
            ),
            padding: EdgeInsets.symmetric(vertical: spacing.md),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        label ?? AppLocalizations.addRecordNext,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: typography.medicalRecordButton.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                    Icon(
                      isRtl ? Icons.arrow_back : Icons.arrow_forward,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
