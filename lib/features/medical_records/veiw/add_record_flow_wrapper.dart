import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/create_record_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_cubit.dart';
import 'package:cureta/features/profile/view_model/profile_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A wrapper widget that provides shared cubits for one add-record flow session.
/// Cubits are created once per flow and disposed when the shell route is removed.
class AddRecordFlowWrapper extends StatefulWidget {
  const AddRecordFlowWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<AddRecordFlowWrapper> createState() => _AddRecordFlowWrapperState();
}

class _AddRecordFlowWrapperState extends State<AddRecordFlowWrapper> {
  late final AddRecordFormCubit _formCubit;
  late final AddRecordStepFourCubit _stepFourCubit;
  late final CreateRecordCubit _createRecordCubit;

  @override
  void initState() {
    super.initState();
    _formCubit = getIt<AddRecordFormCubit>();
    _stepFourCubit = getIt<AddRecordStepFourCubit>();
    _createRecordCubit = getIt<CreateRecordCubit>();
  }

  @override
  void dispose() {
    _formCubit.close();
    _stepFourCubit.close();
    _createRecordCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profilesCubit = context.read<ProfilesListCubit?>();

    if (profilesCubit != null) {
      final state = profilesCubit.state;
      if (state is ProfilesSuccess && state.selectedProfileId != null) {
        _formCubit.setProfileIdIfAbsent(state.selectedProfileId!);
      }
    }

    Widget wrappedChild = widget.child;

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
            _formCubit.setProfileId(state.selectedProfileId!);
          }
        },
        child: wrappedChild,
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<AddRecordFormCubit>.value(value: _formCubit),
        BlocProvider<AddRecordStepFourCubit>.value(value: _stepFourCubit),
        BlocProvider<CreateRecordCubit>.value(value: _createRecordCubit),
      ],
      child: wrappedChild,
    );
  }
}
