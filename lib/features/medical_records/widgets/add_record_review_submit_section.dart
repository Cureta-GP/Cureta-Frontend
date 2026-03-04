import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/create_record_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/create_record_state.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Submit section with loading state handling.
/// Uses BlocSelector to only rebuild when loading state changes.
class AddRecordReviewSubmitSection extends StatelessWidget {
  const AddRecordReviewSubmitSection({
    super.key,
    required this.formState,
    this.onSave,
    this.onCancel,
  });

  final AddRecordFormState formState;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    // Use BlocSelector - only rebuilds when CreateRecordLoading state changes
    return BlocSelector<CreateRecordCubit, CreateRecordState, bool>(
      selector: (state) => state is CreateRecordLoading,
      builder: (context, isLoading) {
        return AddRecordStepTwoBottomBar(
          isLoading: isLoading,
          onNext: onSave ?? _createSubmitHandler(context),
          onSkip: onCancel,
          nextLabel: AppLocalizations.addRecordSaveRecord,
        );
      },
    );
  }

  /// Creates the submit handler that validates and submits.
  /// Validation moved here (can't be in cubit because it depends on formState).
  VoidCallback _createSubmitHandler(BuildContext context) {
    return () {
      // Validation - check required fields
      if (formState.profileId == null) {
        ErrorHandler.show(
          context,
          AppException.validation(msg: 'Profile not selected'),
        );
        return;
      }
      if (formState.diseaseName == null || formState.diseaseName!.isEmpty) {
        ErrorHandler.show(
          context,
          AppException.validation(msg: 'Condition not specified'),
        );
        return;
      }
      if (formState.recordDate == null) {
        ErrorHandler.show(
          context,
          AppException.validation(msg: 'Date not selected'),
        );
        return;
      }

      // Submit via cubit
      context.read<CreateRecordCubit>().submit(
        profileId: formState.profileId!,
        diseaseName: formState.diseaseName!,
        notes: formState.notes,
        recordDate: formState.recordDate!,
        stepFourState: context.read<AddRecordStepFourCubit>().state,
      );
    };
  }
}
