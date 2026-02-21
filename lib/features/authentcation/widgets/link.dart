// widgets/login_link.dart
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback? onTap;

  const Link({
    super.key,
    required this.text,
    required this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          softWrap: true,
          text,
          style: typography.body.copyWith(
            color: colors.textSecondary,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            softWrap: true,
            actionText,
            style: typography.body.copyWith(
              color: colors.primary,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
