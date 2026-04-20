import 'package:cureta/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Image;

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
      child: Image(
        image: AssetImage(AppImages.logo),
      ),
    );
  }
}
