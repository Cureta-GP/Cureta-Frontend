import 'package:cureta/core/constants/app_icons.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/profile/widgets/icon_text_container.dart';
import 'package:flutter/material.dart';

class GenderSelectionStep extends StatelessWidget {
  const GenderSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconTextContainer(
          label: AppLocalizations.profilesGenderMale,
          iconPath: AppIcons.male,
          onTap: () {},
        ),
        IconTextContainer(
          label: AppLocalizations.profilesGenderFemale,
          iconPath: AppIcons.female,
          onTap: () {},
        ),
      ],
    );
  }
}
