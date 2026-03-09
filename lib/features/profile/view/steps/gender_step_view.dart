import 'package:cureta/core/constants/app_icons.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/profile/view_model/profile_cubit.dart';
import 'package:cureta/features/profile/widgets/icon_text_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenderSelectionStep extends StatelessWidget {
  const GenderSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileCubit>().state;
    final cubit = context.read<ProfileCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconTextContainer(
          label: AppLocalizations.profilesGenderMale,
          iconPath: AppIcons.male,
          isSelected: state.gender == 'male',
          onTap: () => cubit.updateGender('male'),
        ),
        IconTextContainer(
          label: AppLocalizations.profilesGenderFemale,
          iconPath: AppIcons.female,
          isSelected: state.gender == 'female',
          onTap: () => cubit.updateGender('female'),
        ),
      ],
    );
  }
}