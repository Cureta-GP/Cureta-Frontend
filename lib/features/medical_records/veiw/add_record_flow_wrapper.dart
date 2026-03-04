import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/create_record_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddRecordFormCubit>.value(
          value: getIt<AddRecordFormCubit>(),
        ),
        BlocProvider<AddRecordStepFourCubit>.value(
          value: getIt<AddRecordStepFourCubit>(),
        ),
        BlocProvider<CreateRecordCubit>.value(
          value: getIt<CreateRecordCubit>(),
        ),
      ],
      child: child,
    );
  }
}
