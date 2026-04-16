import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerRecordCard extends StatelessWidget {
  const ShimmerRecordCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return Shimmer.fromColors(
      baseColor: colors.surface,
      highlightColor: colors.divider,
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(radius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status pill placeholder
            Container(
              width: 72,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius.full),
              ),
            ),
            SizedBox(height: spacing.md),
            // Title placeholder
            Container(
              width: double.infinity,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius.sm),
              ),
            ),
            SizedBox(height: spacing.md),
            // Meta row placeholder
            Container(
              width: 140,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius.sm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a list of shimmer cards (default 4).
class ShimmerRecordsList extends StatelessWidget {
  const ShimmerRecordsList({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(spacing.lg, spacing.lg, spacing.lg, 0),
      itemCount: count,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: spacing.lg),
          child: const ShimmerRecordCard(),
        );
      },
    );
  }
}
