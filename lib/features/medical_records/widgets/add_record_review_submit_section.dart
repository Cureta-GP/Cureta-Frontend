import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/create_record_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/create_record_state.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_two_bottom_bar.dart';
import 'package:cureta/shared/widgets/loading_overlay.dart';
import 'package:cureta/shared/widgets/success_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return BlocListener<CreateRecordCubit, CreateRecordState>(
      listener: (context, state) {
        if (state is CreateRecordLoading) {
          LoadingOverlay.show(
            context,
            lottiePath: 'assets/animations/loading.json',
          );
        } else if (state is CreateRecordSuccess) {
          LoadingOverlay.hide();
          SuccessOverlay.show(
            context,
            lottiePath: 'assets/animations/check mark.json',
            message: 'تم حفظ السجل بنجاح',
            onFinished: () {
              context.read<AddRecordFormCubit>().reset();
              context.read<AddRecordStepFourCubit>().reset();
              context.read<CreateRecordCubit>().reset();
              GoRouter.of(context).go('${AppRoutes.mainNavigation}?tab=2');
            },
          );
        } else if (state is CreateRecordFailure) {
          LoadingOverlay.hide();
          ErrorHandler.show(context, state.error);
        } else {
          LoadingOverlay.hide();
        }
      },
      child: AddRecordStepTwoBottomBar(
        onNext: onSave ?? _createSubmitHandler(context),
        onSkip: onCancel,
        nextLabel: AppLocalizations.addRecordSaveRecord,
      ),
    );
  }

  /// Creates the submit handler that validates and submits.
  /// Validation moved here (can't be in cubit because it depends on formState).
  VoidCallback _createSubmitHandler(BuildContext context) {
    return () {
      // Validation - check required fields
      if (formState.diseaseName == null || formState.diseaseName!.isEmpty) {
        ErrorHandler.show(
          context,
          AppException.validation(msg: AppLocalizations.addRecordErrorConditionRequired),
        );
        return;
      }
      if (formState.recordDate == null) {
        ErrorHandler.show(
          context,
          AppException.validation(msg: AppLocalizations.addRecordErrorDateRequired),
        );
        return;
      }
      // Submit via cubit
      context.read<CreateRecordCubit>().submit(
        profileId: formState.profileId,
        diseaseName: formState.diseaseName!,
        notes: formState.notes,
        recordDate: formState.recordDate!,
        stepFourState: context.read<AddRecordStepFourCubit>().state,
      );
    };
  }
}
