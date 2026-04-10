import 'package:flutter/material.dart';

import '../../../core/theme/theme_extensions.dart';

class ChatBotAvatar extends StatelessWidget {
  const ChatBotAvatar({super.key, this.size = 32});
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = context.radius;

    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        color: colors.accentCyan,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.full),
        ),
      ),
      child: Icon(
        Icons.smart_toy,
        size: size * 0.56,
        color: colors.primary,
      ),
    );
  }
}
