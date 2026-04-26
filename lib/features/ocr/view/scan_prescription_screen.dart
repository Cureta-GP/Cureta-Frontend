import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class ScanPrescriptionScreen extends StatelessWidget {
  const ScanPrescriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.scanPrescriptionTitle),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {},
            tooltip: AppLocalizations.scanPrescriptionFlash,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: EdgeInsets.all(spacing.xl),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.accentCyan, width: 3),
                  borderRadius: BorderRadius.circular(context.radius.lg),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      // TODO: Replace with camera preview widget
                      Center(
                        child: Text(
                          AppLocalizations.scanPrescriptionCameraPreview,
                          style: typography.body.copyWith(
                            color: colors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () {},
                  tooltip: AppLocalizations.scanPrescriptionGallery,
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.camera_alt),
                  tooltip: AppLocalizations.scanPrescriptionCapture,
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {},
                  tooltip: AppLocalizations.scanPrescriptionTips,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: spacing.lg),
            child: Text(
              AppLocalizations.scanPrescriptionPositionHint,
              style: typography.label.copyWith(color: colors.textHint),
            ),
          ),
        ],
      ),
    );
  }
}
