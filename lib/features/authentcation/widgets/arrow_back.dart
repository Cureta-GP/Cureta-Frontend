import 'package:cureta/core/styling/app_colors.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:flutter/material.dart';

class ArrowBack extends StatelessWidget {
  const ArrowBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: ShapeDecoration(
        color: const Color(0x1945ABB5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(67108896),
        ),
      ),
      child: IconButton(
        onPressed: () => Nav.back(context),
        icon: const Icon(Icons.arrow_back, color: AppColors.primary),
      ),
    );
  }
}
