import 'package:cureta/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/theme_extensions.dart';
import 'send_button.dart';
/// Row containing the attach button, text field,
/// microphone button, and send button.
class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,
    this.controller,
    this.onSend,
    this.onAttach,
    this.onMic,
  });

  /// Controller for the text input.
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
    final typography = context.typography;
    final spacing = context.spacing;
    final radius = context.radius;

    return Container(
      padding: EdgeInsets.all(spacing.xs),
      decoration: ShapeDecoration(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.lg),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: colors.icon,
            ),
            onPressed: onAttach,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: typography.chatMessageBody.copyWith(
                color: colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.chatInputHint,
                hintStyle:
                    typography.chatMessageBody.copyWith(
                  color: colors.textHint,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: spacing.xs * 0.5,
                  vertical: spacing.xs,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.mic, color: colors.icon),
            onPressed: onMic,
          ),
          SendButton(
            onPressed: onSend,
            radius: radius.xl,
            color: colors.primary,
          ),
        ],
      ),
    );
  }
}
