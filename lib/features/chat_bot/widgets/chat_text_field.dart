import 'package:cureta/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

import 'send_button.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,
    this.controller,
    this.onSend,
    this.onAttach,
    this.onMic,
    this.isLoading = false,
  });

  final TextEditingController? controller;
  final VoidCallback? onSend;
  final VoidCallback? onAttach;
  final VoidCallback? onMic;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildActionButton(
            context,
            icon: Icons.attach_file,
            onPressed: onAttach,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 5,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.chatInputHint,
                hintStyle: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend?.call(),
            ),
          ),
          _buildActionButton(context, icon: Icons.mic_none, onPressed: onMic),
          SendButton(onPressed: isLoading ? null : onSend, isLoading: false),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 45,
      height: 45,
      margin: const EdgeInsetsDirectional.only(end: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 22,
        icon: Icon(icon, color: colorScheme.primary),
        onPressed: onPressed ?? () {},
      ),
    );
  }
}
