import 'dart:io';

import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/ocr/data/repo/ocr_repository.dart';
import 'package:cureta/features/ocr/view_model/ocr_cubit.dart';
import 'package:cureta/features/ocr/view_model/ocr_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/core/config/routing/app_routes.dart';

class ScanPrescriptionScreen extends StatelessWidget {
  const ScanPrescriptionScreen({super.key});

  Future<void> _handleImagePick(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null && context.mounted) {
        final file = File(image.path);
        context.read<OcrCubit>().scanPrescription(file);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في اختيار الصورة: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OcrCubit(repository: getIt.get<OcrRepository>()),
      child: BlocListener<OcrCubit, OcrState>(
        listener: (context, state) {
          if (state is OcrScanSuccess) {
            context.pushNamed(
              AppRoutes.scannedMedicines,
              extra: state.response.extractedMedicines,
            );
          } else if (state is OcrFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.scanPrescriptionTitle)),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(context.spacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Icon(
                      Icons.document_scanner_outlined,
                      size: 120,
                      color: context.colors.primary.withOpacity(0.4),
                    ),
                    SizedBox(height: context.spacing.xl),
                    Text(
                      AppLocalizations.scanPrescriptionPositionHint,
                      textAlign: TextAlign.center,
                      style: context.typography.body,
                    ),
                    const Spacer(),
                    BlocBuilder<OcrCubit, OcrState>(
                      builder: (context, state) {
                        final isLoading = state is OcrLoading;
                        return ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => _handleImagePick(
                                  context,
                                  ImageSource.camera,
                                ),
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: Text(AppLocalizations.scanPrescriptionCapture),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(context.spacing.md),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: context.spacing.md),
                    BlocBuilder<OcrCubit, OcrState>(
                      builder: (context, state) {
                        final isLoading = state is OcrLoading;
                        return OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => _handleImagePick(
                                  context,
                                  ImageSource.gallery,
                                ),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: Text(AppLocalizations.scanPrescriptionGallery),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(context.spacing.md),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Loading overlay
              BlocBuilder<OcrCubit, OcrState>(
                builder: (context, state) {
                  if (state is OcrLoading) {
                    return Container(
                      color: Colors.black54,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
