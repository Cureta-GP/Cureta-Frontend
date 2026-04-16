import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';

/// Reusable profile card widget for displaying a single profile option
class ProfileCard extends StatelessWidget {
  /// Profile name to display
  final String name;

  /// Profile relationship/role (e.g., "Primary Account (You)", "Spouse", "Son")
  final String relationship;

  /// Avatar URL or asset path
  final String? avatarUrl;

  /// Callback when profile card is tapped
  final VoidCallback onTap;

  /// Whether this profile is currently selected
  final bool isSelected;

  const ProfileCard({
    super.key,
    required this.name,
    required this.relationship,
    required this.onTap,
    this.avatarUrl,
    this.isSelected = false,
  });

  /// Get initials from name for avatar
  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '?';
    final initials = parts.take(2).map((e) => e.isNotEmpty ? e[0] : '').join();
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius.md),
        child: Container(
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: isSelected ? colors.accentCyan : colors.surface,
            borderRadius: BorderRadius.circular(radius.md),
            border: Border.all(
              color: isSelected ? colors.primary : colors.divider,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: spacing.xxl + spacing.lg,
                height: spacing.xxl + spacing.lg,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _getInitials(name),
                    style: typography.title.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: spacing.lg),
              // Profile information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: typography.title.copyWith(
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      relationship,
                      style: typography.body.copyWith(
                        color: colors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Selected badge
              if (isSelected)
                Container(
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(spacing.xs),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: spacing.lg,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
