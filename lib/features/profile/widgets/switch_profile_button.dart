import 'package:flutter/material.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class SwitchProfileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final double minHeight;
  final double paddingVertical;

  const SwitchProfileButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderRadius,
    required this.minHeight,
    required this.paddingVertical,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.swap_horiz),
          label: Text(AppLocalizations.profilesSwitchProfile),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: paddingVertical),
          ),
        ),
      ),
    );
  }
}
