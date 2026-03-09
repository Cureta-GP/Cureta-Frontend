import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/view_model/profile_cubit.dart';
import 'package:cureta/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameInputStep extends StatefulWidget {
  const NameInputStep({super.key});

  @override
  State<NameInputStep> createState() => _NameInputStepState();
}

class _NameInputStepState extends State<NameInputStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();
    _controller = TextEditingController(text: cubit.state.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.spacing.lg),
      child: CustomTextField(
        hint: AppLocalizations.profilesNameHint,
        onChanged: (val) => context.read<ProfileCubit>().updateName(val),
        label: '',
        controller: _controller,
      ),
    );
  }
}
