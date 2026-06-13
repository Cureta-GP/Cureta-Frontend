import 'package:flutter/material.dart';

import 'chat_text_field.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    this.controller,
    this.onSend,
    this.onAttach,
    this.onMic,
    this.compactMode = false,
    this.isLoading = false,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onSend;
  final VoidCallback? onAttach;
  final VoidCallback? onMic;
  final bool compactMode;
  final bool isLoading;

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
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    widget.onSend?.call(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final keyboardOpen = bottomInset > 0;
    final compact = widget.compactMode || (keyboardOpen && isLandscape);

    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, keyboardOpen ? 4 : 14),
      child: ChatTextField(
        controller: _controller,
        onSend: _handleSend,
        onAttach: widget.onAttach,
        onMic: widget.onMic,
        compactMode: compact,
        isLoading: widget.isLoading,
      ),
    );
  }
}
