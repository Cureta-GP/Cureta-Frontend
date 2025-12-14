// widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:cureta/core/styling/app_colors.dart';

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
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          shadowColor: AppColors.primaryDark,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
