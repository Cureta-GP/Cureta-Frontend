import 'package:cureta/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginHeader extends StatelessWidget {
  final Artboard? riveArtboard;

  const LoginHeader({super.key, required this.riveArtboard});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      width: double.infinity,
      child: riveArtboard == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 80,
                    color: Colors.blue.shade300,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.loadingAnimation,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            )
          : Rive(artboard: riveArtboard!, fit: BoxFit.cover),
    );
  }
}
