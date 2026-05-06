import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

/// Animated pulsing circle behind the medicine image (or fallback icon).
class AlarmPulseImageWidget extends StatelessWidget {
  const AlarmPulseImageWidget({
    super.key,
    required this.animation,
    required this.scaleAnimation,
    required this.fadeAnimation,
    this.imagePath,
  });

  final Animation<double> animation;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Expanding glow ring
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Transform.scale(
              scale: scaleAnimation.value,
              child: Opacity(
                opacity: fadeAnimation.value,
                child: Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
          _buildImage(colors),
        ],
      ),
    );
  }

  Widget _buildImage(dynamic colors) {
    if (imagePath != null && imagePath!.isNotEmpty) {
      final file = File(imagePath!);
      if (file.existsSync()) {
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.surface, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: colors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: colors.primary, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(Icons.medication, size: 96, color: colors.primary),
    );
  }
}
