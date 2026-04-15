import 'package:flutter/material.dart';

class ChatBotAvatar extends StatelessWidget {
  const ChatBotAvatar({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.local_hospital_outlined,
        size: size * 0.56,
        color: colorScheme.primary,
      ),
    );
  }
}
