// widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String prefixIcon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.prefixIcon = '',
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return SizedBox(
      width: double.infinity,
      height: spacing.xxl + spacing.lg,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.md),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: typography.button.copyWith(
            color: Colors.white,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
