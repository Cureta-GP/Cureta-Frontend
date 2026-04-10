import 'package:flutter/material.dart';

import '../../../core/theme/theme_extensions.dart';
import 'chat_text_field.dart';

/// Bottom input area for the chat screen.
///
/// Composes [ChatTextField] in a themed container.
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    this.controller,
    this.onSend,
    this.onAttach,
    this.onMic,
  });

  /// Controller for the text input field.
  final TextEditingController? controller;

  /// Called when the send button is pressed.
  final VoidCallback? onSend;

  /// Called when the attach button is pressed.
  final VoidCallback? onAttach;

  /// Called when the microphone button is pressed.
  final VoidCallback? onMic;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.only(
        top: spacing.xs,
        left: spacing.lg,
        right: spacing.lg,
        bottom: spacing.xxl,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(width: 0.8, color: colors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatTextField(
            controller: controller,
            onSend: onSend,
            onAttach: onAttach,
            onMic: onMic,
          ),
        ],
      ),
    );
  }
}
