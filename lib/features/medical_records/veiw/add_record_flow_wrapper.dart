import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/create_record_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A wrapper widget that provides shared cubits for the entire add record flow.
/// This ensures AddRecordFormCubit, AddRecordStepFourCubit, and CreateRecordCubit survive
/// across step navigations and share state.
class AddRecordFlowWrapper extends StatelessWidget {
  const AddRecordFlowWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final formCubit = getIt<AddRecordFormCubit>();

    final profilesCubit = context.read<ProfilesListCubit?>();
    if (profilesCubit != null) {
      final state = profilesCubit.state;
      if (state is ProfilesSuccess && state.selectedProfileId != null) {
        formCubit.setProfileIdIfAbsent(state.selectedProfileId!);
      }
    }

    Widget wrappedChild = child;
    if (profilesCubit != null) {
      wrappedChild = BlocListener<ProfilesListCubit, ProfilesListState>(
        listenWhen: (prev, curr) {
          final prevId = prev is ProfilesSuccess
              ? prev.selectedProfileId
              : null;
          final currId = curr is ProfilesSuccess
              ? curr.selectedProfileId
              : null;
          return prevId != currId && currId != null;
        },
        listener: (context, state) {
          if (state is ProfilesSuccess && state.selectedProfileId != null) {
            context.read<AddRecordFormCubit>().setProfileId(
              state.selectedProfileId!,
            );
          }
        },
        child: child,
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<AddRecordFormCubit>.value(value: formCubit),
        BlocProvider<AddRecordStepFourCubit>.value(
          value: getIt<AddRecordStepFourCubit>(),
        ),
        BlocProvider<CreateRecordCubit>.value(
          value: getIt<CreateRecordCubit>(),
        ),
      ],
      child: wrappedChild,
    );
  }
}
