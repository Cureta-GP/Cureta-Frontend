import 'package:cureta/features/profile/data/models/profile_model.dart';
import 'package:flutter/material.dart';

class SelectedProfileCard extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback onTap;
  final Color accentColor;
  final Color borderColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color primaryColor;
  final double borderRadius;
  final double avatarSize;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;

  const SelectedProfileCard({
    super.key,
    required this.profile,
    required this.onTap,
    required this.accentColor,
    required this.borderColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.primaryColor,
    required this.borderRadius,
    required this.avatarSize,
    required this.titleStyle,
    required this.bodyStyle,
  });

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.isEmpty) return '?';
    final initials = parts.take(2).map((e) => e.isNotEmpty ? e[0] : '').join();
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(avatarSize / 2.5),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _getInitials(profile.fullName),
                  style: titleStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: avatarSize / 2.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullName,
                    style: titleStyle.copyWith(color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: avatarSize / 6),
                  Text(
                    profile.relationship,
                    style: bodyStyle.copyWith(
                      color: secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: borderColor,
              size: avatarSize / 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
