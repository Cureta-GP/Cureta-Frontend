import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MedicineListShimmerWidget extends StatelessWidget {
  const MedicineListShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Shimmer.fromColors(
      baseColor: context.colors.divider,
      highlightColor: context.colors.surface,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.only(
          start: spacing.xl,
          end: spacing.xl,
          top: spacing.md,
          bottom: spacing.xxl * 4,
        ),
        itemCount: 5,
        separatorBuilder: (_, _) => SizedBox(height: spacing.md),
        itemBuilder: (_, _) => Container(
          height: 100,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(context.radius.lg),
          ),
        ),
      ),
    );
  }
}
