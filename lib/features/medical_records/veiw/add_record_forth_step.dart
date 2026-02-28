import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/models/add_record_uploaded_file.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_cubit.dart';
import 'package:cureta/features/medical_records/widgets/add_record_step_four_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddRecordForthStep extends StatefulWidget {
  const AddRecordForthStep({
    super.key,
    this.onBack,
    this.onContinue,
    this.onSkip,
    this.onPrescriptionTap,
    this.onLabTestTap,
    this.onScanTap,
  });

  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final VoidCallback? onSkip;
  final VoidCallback? onPrescriptionTap;
  final VoidCallback? onLabTestTap;
  final VoidCallback? onScanTap;

  @override
  State<AddRecordForthStep> createState() => _AddRecordForthStepState();
}

class _AddRecordForthStepState extends State<AddRecordForthStep> {
  Future<void> _handleViewFile(
    BuildContext scopedContext,
    AddRecordUploadedFile file,
  ) async {
    final isOpened = await scopedContext
        .read<AddRecordStepFourCubit>()
        .viewFile(file);
    if (!isOpened) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(scopedContext).showSnackBar(
        const SnackBar(content: Text('Unable to open this file.')),
      );
    }
  }

  Future<void> _handlePrescriptionTap(BuildContext scopedContext) async {
    if (widget.onPrescriptionTap != null) {
      widget.onPrescriptionTap!.call();
      return;
    }
    await scopedContext.read<AddRecordStepFourCubit>().pickRecordFile(
      AddRecordUploadCategory.prescription,
    );
  }

  Future<void> _handleLabTestTap(BuildContext scopedContext) async {
    if (widget.onLabTestTap != null) {
      widget.onLabTestTap!.call();
      return;
    }
    await scopedContext.read<AddRecordStepFourCubit>().pickRecordFile(
      AddRecordUploadCategory.labTest,
    );
  }

  Future<void> _handleScanTap(BuildContext scopedContext) async {
    if (widget.onScanTap != null) {
      widget.onScanTap!.call();
      return;
    }
    await scopedContext.read<AddRecordStepFourCubit>().pickRecordFile(
      AddRecordUploadCategory.scan,
    );
  }

  void _handleContinue(BuildContext context) {
    if (widget.onContinue != null) {
      widget.onContinue!.call();
      return;
    }
    GoRouter.of(context).pushNamed(AppRoutes.addRecordStepFive);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocProvider(
      create: (_) => AddRecordStepFourCubit(),
      child: Builder(
        builder: (scopedContext) => Scaffold(
          backgroundColor: colors.medicalRecordBackground,
          body: SafeArea(
            child: AddRecordStepFourBody(
              onBack: widget.onBack,
              onContinue: () => _handleContinue(scopedContext),
              onSkip: widget.onSkip,
              onViewFile: (_, file) {
                _handleViewFile(scopedContext, file);
              },
              onDeleteFile: (category, file) {
                scopedContext.read<AddRecordStepFourCubit>().deleteFile(
                  category,
                  file,
                );
              },
              onPrescriptionTap: () {
                _handlePrescriptionTap(scopedContext);
              },
              onLabTestTap: () {
                _handleLabTestTap(scopedContext);
              },
              onScanTap: () {
                _handleScanTap(scopedContext);
              },
            ),
          ),
        ),
      ),
    );
  }
}
