import 'package:flutter/material.dart';

import '../../../core/theme/theme_extensions.dart';
import 'chat_text_field.dart';

/// Bottom input area for the chat screen.
///
/// Composes [ChatTextField] in a themed container.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    this.controller,
    this.onSend,
    this.onAttach,
    this.onMic,
  });

  /// Controller for the text input field.
  final TextEditingController? controller;

  /// Called when the send button is pressed with the message text.
  final Function(String)? onSend;

  /// Called when the attach button is pressed.
  final VoidCallback? onAttach;

  /// Called when the microphone button is pressed.
  final VoidCallback? onMic;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleSend() {
    if (_controller.text.isNotEmpty) {
      widget.onSend?.call(_controller.text);
      _controller.clear();
    }
  }

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
            controller: _controller,
            onSend: _handleSend,
            onAttach: widget.onAttach,
            onMic: widget.onMic,
          ),
        ],
      ),
    );
  }
}
