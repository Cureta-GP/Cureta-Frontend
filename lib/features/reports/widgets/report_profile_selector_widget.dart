import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';

class ReportProfileSelectorWidget extends StatelessWidget {
  const ReportProfileSelectorWidget({
    super.key,
    required this.profiles,
    required this.selectedProfile,
    required this.onSelected,
  });

  final List<ProfileModel> profiles;
  final ProfileModel? selectedProfile;
  final ValueChanged<ProfileModel> onSelected;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return SizedBox(
      height: spacing.xxl * 3.75,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(horizontal: spacing.xl),
        separatorBuilder: (_, _) => SizedBox(width: spacing.md),
        itemCount: profiles.length,
        itemBuilder: (_, i) => _ProfileChip(
          profile: profiles[i],
          isSelected: selectedProfile?.id == profiles[i].id,
          onTap: () => onSelected(profiles[i]),
        ),
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({
    required this.profile,
    required this.isSelected,
    required this.onTap,
  });

  final ProfileModel profile;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius.lg),
      child: AnimatedContainer(
        duration: context.durations.normal,
        width: spacing.xxl * 3.25,
        padding: EdgeInsets.all(spacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? colors.secondary : colors.surface,
          borderRadius: BorderRadius.circular(radius.lg),
          border: Border.all(
            color: isSelected ? colors.primary : colors.divider,
            width: isSelected ? 2 : spacing.hairline,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _Avatar(profile: profile, size: spacing.xxl),
                if (profile.isPrimary)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Icon(
                      Icons.star_rounded,
                      color: colors.primary,
                      size: spacing.md,
                    ),
                  ),
              ],
            ),
            SizedBox(height: spacing.xs / 2),
            Text(
              profile.fullName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: typography.medicalRecordProgress.copyWith(
                color: isSelected ? colors.primary : colors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                height: 1,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xs / 4),
            Text(
              profile.relationship,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: typography.label.copyWith(
                color: colors.textSecondary,
                height: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.profile, required this.size});
  final ProfileModel profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final hasImage = profile.imageUrl != null && profile.imageUrl!.isNotEmpty;
    final initial = profile.fullName.isNotEmpty
        ? profile.fullName[0].toUpperCase()
        : '?';

    if (hasImage) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: colors.accentCyan,
        backgroundImage: CachedNetworkImageProvider(profile.imageUrl!),
      );
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: colors.accentCyan,
      child: Text(
        initial,
        style: typography.medicalRecordScreenTitle.copyWith(
          color: colors.primary,
        ),
      ),
    );
  }
}

// ── Loading shimmer ─────────────────────────────────────────────────────────

class ReportProfileSelectorShimmer extends StatelessWidget {
  const ReportProfileSelectorShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return SizedBox(
      height: spacing.xxl * 3.75,
      child: Shimmer.fromColors(
        baseColor: colors.divider,
        highlightColor: colors.surface,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsetsDirectional.symmetric(horizontal: spacing.xl),
          separatorBuilder: (_, _) => SizedBox(width: spacing.md),
          itemCount: 4,
          itemBuilder: (_, _) => Container(
            width: spacing.xxl * 3.25,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(radius.lg),
            ),
          ),
        ),
      ),
    );
  }
}
