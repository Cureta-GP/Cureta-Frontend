import 'package:cureta/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/theme_extensions.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.health_and_safety_outlined,
                color: colors.primary,
                size: 34,
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              AppLocalizations.chatGreetingMessage,
              textAlign: TextAlign.center,
              style: context.typography.chatMessageBody.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
