import 'package:cureta/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class NameInputStep extends StatelessWidget {
  const NameInputStep({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: AppLocalizations.profilesNameHint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
