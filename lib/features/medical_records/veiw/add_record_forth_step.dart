import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/data/models/add_record_uploaded_file.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_state.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_four_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddRecordForthStep extends StatelessWidget {
  const AddRecordForthStep({
    super.key,
    this.onBack,
    this.onContinue,
    this.onSkip,
    this.onPrescriptionTap,
    this.onLabTestTap,
    this.onScanTap,
    this.onReportTap,
    this.onOtherTap,
  });

  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final VoidCallback? onSkip;
  final VoidCallback? onPrescriptionTap;
  final VoidCallback? onLabTestTap;
  final VoidCallback? onScanTap;
  final VoidCallback? onReportTap;
  final VoidCallback? onOtherTap;

  void _handlePrescriptionTap(BuildContext context) {
    if (onPrescriptionTap != null) {
      onPrescriptionTap!.call();
      return;
    }
    context.read<AddRecordStepFourCubit>().pickRecordFile(
      AddRecordUploadCategory.prescription,
    );
  }

  void _handleLabTestTap(BuildContext context) {
    if (onLabTestTap != null) {
      onLabTestTap!.call();
      return;
    }
    context.read<AddRecordStepFourCubit>().pickRecordFile(
      AddRecordUploadCategory.labTest,
    );
  }

  void _handleScanTap(BuildContext context) {
    if (onScanTap != null) {
      onScanTap!.call();
      return;
    }
    context.read<AddRecordStepFourCubit>().pickRecordFile(
      AddRecordUploadCategory.scan,
    );
  }

  void _handleReportTap(BuildContext context) {
    if (onReportTap != null) {
      onReportTap!.call();
      return;
    }
    context.read<AddRecordStepFourCubit>().pickRecordFile(
      AddRecordUploadCategory.report,
    );
  }

  void _handleOtherTap(BuildContext context) {
    if (onOtherTap != null) {
      onOtherTap!.call();
      return;
    }
    context.read<AddRecordStepFourCubit>().pickRecordFile(
      AddRecordUploadCategory.other,
    );
  }

  void _handleContinue(BuildContext context) {
    if (onContinue != null) {
      onContinue!.call();
      return;
    }
    GoRouter.of(context).pushNamed(AppRoutes.addRecordStepFive);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocListener<AddRecordStepFourCubit, AddRecordStepFourState>(
          listenWhen: (previous, current) =>
              current.fileOpenError != null &&
              previous.fileOpenError != current.fileOpenError,
          listener: (context, state) {
            if (state.fileOpenError != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.fileOpenError!)));
            }
          },
          child: AddRecordStepFourBody(
            onBack: onBack,
            onContinue: () => _handleContinue(context),
            onSkip: onSkip,
            onViewFile: (_, file) {
              context.read<AddRecordStepFourCubit>().viewFile(file);
            },
            onDeleteFile: (category, file) {
              context.read<AddRecordStepFourCubit>().deleteFile(category, file);
            },
            onPrescriptionTap: () => _handlePrescriptionTap(context),
            onLabTestTap: () => _handleLabTestTap(context),
            onScanTap: () => _handleScanTap(context),
            onReportTap: () => _handleReportTap(context),
            onOtherTap: () => _handleOtherTap(context),
          ),
        ),
      ),
    );
  }
}
