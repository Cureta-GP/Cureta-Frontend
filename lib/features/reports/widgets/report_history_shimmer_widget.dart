import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

class ReportHistoryShimmerWidget extends StatelessWidget {
  const ReportHistoryShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return Shimmer.fromColors(
      baseColor: colors.divider,
      highlightColor: colors.surface,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: spacing.xl,
          vertical: spacing.md,
        ),
        itemCount: 5,
        separatorBuilder: (_, _) => SizedBox(height: spacing.md),
        itemBuilder: (_, _) => Container(
          height: 72,
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(radius.lg),
          ),
        ),
      ),
    );
  }
}
