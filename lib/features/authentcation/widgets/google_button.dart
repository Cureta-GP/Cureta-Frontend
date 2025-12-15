// widgets/google_button.dart
import 'package:cureta/core/constants/app_images.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 2, color: Color(0xFFD0D5DB)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.google, width: 30, height: 30),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.continueWithGoogle,
              style: const TextStyle(
                color: Color(0xFF354152),
                fontSize: 16,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
