// widgets/signup_header.dart
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String subtitle;
  const Header({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: spacing.xxl, bottom: spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: typography.hero.copyWith(
                color: colors.primaryDark,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: spacing.md),
            SizedBox(
              width: double.infinity,
              child: Text(
                subtitle,
                style: typography.body.copyWith(
                  color: colors.textSecondary,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
