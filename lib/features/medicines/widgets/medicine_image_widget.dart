import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class MedicineImageWidget extends StatelessWidget {
  const MedicineImageWidget({
    super.key,
    required this.imagePath,
    required this.size,
  });
  final String? imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final file = imagePath != null && imagePath!.isNotEmpty
        ? File(imagePath!)
        : null;
    final hasFile = file != null && file.existsSync();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.1) ,
        color: colors.secondary,
        //shape: BoxShape.circle,
        border: Border.all(color: colors.primary, width: spacing.hairline),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: 0.08),
            blurRadius: spacing.md,
            spreadRadius: spacing.xs,
          ),
        ],
        image: hasFile
            ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
            : null,
      ),
      child: hasFile
          ? null
          : Icon(Icons.medication, size: size * 0.5, color: colors.primary),
    );
  }
}
