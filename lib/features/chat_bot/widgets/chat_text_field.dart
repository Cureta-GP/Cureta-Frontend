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
    this.compactMode = false,
    this.isLoading = false,
  });

  final TextEditingController? controller;
  final VoidCallback? onSend;
  final VoidCallback? onAttach;
  final VoidCallback? onMic;
  final bool compactMode;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final actionButtonSize = compactMode ? 38.0 : 45.0;
    final actionIconSize = compactMode ? 20.0 : 22.0;
    final rowVerticalPadding = compactMode ? 4.0 : 6.0;
    final fieldVerticalPadding = compactMode ? 6.0 : 10.0;
    final borderRadius = compactMode ? 22.0 : 26.0;
    final inputMaxLines = compactMode ? 3 : 5;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: rowVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
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
            size: actionButtonSize,
            iconSize: actionIconSize,
            marginEnd: compactMode ? 2 : 4,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: inputMaxLines,
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
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: fieldVerticalPadding,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend?.call(),
            ),
          ),
          _buildActionButton(
            context,
            icon: Icons.mic_none,
            onPressed: onMic,
            size: actionButtonSize,
            iconSize: actionIconSize,
            marginEnd: compactMode ? 2 : 4,
          ),
          SendButton(onPressed: isLoading ? null : onSend, isLoading: false),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onPressed,
    required double size,
    required double iconSize,
    required double marginEnd,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      margin: EdgeInsetsDirectional.only(end: marginEnd),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: iconSize,
        icon: Icon(icon, color: colorScheme.primary),
        onPressed: onPressed ?? () {},
      ),
    );
  }
}
