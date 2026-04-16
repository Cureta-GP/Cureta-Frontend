import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../veiw_model/chat_cubit.dart';
import 'chat_empty_state.dart';
import 'scroll_to_bottom_fab.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({
    super.key,
    required this.cubit,
    required this.isLoading,
    required this.isEmpty,
    required this.scrollController,
    required this.isUserScrolledAway,
    required this.onScrollNotification,
    this.onMessageSend,
    required this.onAttachmentTap,
    required this.onJumpToBottom,
  });

  final ChatCubit cubit;
  final bool isLoading;
  final bool isEmpty;
  final ScrollController scrollController;
  final bool isUserScrolledAway;
  final bool Function(ScrollNotification) onScrollNotification;
  final ValueChanged<String>? onMessageSend;
  final VoidCallback? onAttachmentTap;
  final VoidCallback onJumpToBottom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
          ),
        ),
        Chat(
          backgroundColor: theme.scaffoldBackgroundColor,
          builders: Builders(
            chatAnimatedListBuilder: (context, itemBuilder) {
              return NotificationListener<ScrollNotification>(
                onNotification: onScrollNotification,
                child: ChatAnimatedList(
                  scrollController: scrollController,
                  itemBuilder: itemBuilder,
                  topPadding: 2,
                  bottomPadding: 0,
                  handleSafeArea: false,
                ),
              );
            },
            textMessageBuilder: _buildTextMessage,
            emptyChatListBuilder: (context) => const SizedBox.shrink(),
            composerBuilder: (context) => const SizedBox.shrink(),
            scrollToBottomBuilder: (context, animation, onPressed) {
              return const SizedBox.shrink();
            },
          ),
          chatController: cubit.chatController,
          currentUserId: cubit.currentUser.id,
          onAttachmentTap: onAttachmentTap,
          onMessageSend: onMessageSend,
          resolveUser: cubit.resolveUser,
          theme: ChatTheme.fromThemeData(theme),
        ),
        if (isEmpty) const ChatEmptyState(),
        ScrollToBottomFab(
          isVisible: isUserScrolledAway,
          onPressed: onJumpToBottom,
        ),
      ],
    );
  }

  Widget _buildTextMessage(
    BuildContext context,
    TextMessage message,
    int index, {
    required bool isSentByMe,
    MessageGroupStatus? groupStatus,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final messageForeground = isSentByMe
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final baseTextStyle =
        (textTheme.bodyLarge ?? textTheme.bodyMedium ?? const TextStyle())
            .copyWith(
              color: messageForeground,
              height: 1.5,
              decoration: TextDecoration.none,
            );
    final timeStyle = (textTheme.labelSmall ?? const TextStyle()).copyWith(
      color: messageForeground.withValues(alpha: 0.78),
      decoration: TextDecoration.none,
    );
    final shouldAnimate = !isSentByMe && (message.metadata?['animate'] == true);
    final timestamp = _formatTimestamp(context, message.createdAt);

    final bubbleAlignment = isSentByMe
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final bubbleRadius = isSentByMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(0),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(16),
          );

    final bubbleColor = isSentByMe
        ? colorScheme.primary
        : colorScheme.surfaceContainerHigh;

    Widget messageText = Text(
      message.text,
      textAlign: TextAlign.start,
      style: baseTextStyle,
    );

    if (shouldAnimate) {
      messageText = AnimatedTextKit(
        key: ValueKey('typewriter_${message.id}_${message.text.hashCode}'),
        isRepeatingAnimation: false,
        totalRepeatCount: 1,
        animatedTexts: [
          TypewriterAnimatedText(
            message.text,
            speed: const Duration(milliseconds: 24),
            textStyle: baseTextStyle,
            textAlign: TextAlign.start,
          ),
        ],
        onFinished: () {
          cubit.chatController.updateMessage(
            message,
            message.copyWith(
              metadata: <String, dynamic>{
                ...?message.metadata,
                'animate': false,
              },
            ),
          );
          cubit.onMessageInserted?.call();
        },
      );

      // Keep the list anchored to bottom while animated text expands lines.
      messageText = NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (_) {
          cubit.onMessageInserted?.call();
          return false;
        },
        child: SizeChangedLayoutNotifier(child: messageText),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Align(
          alignment: bubbleAlignment,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: bubbleRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    messageText,
                    if (timestamp.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        timestamp,
                        textAlign: TextAlign.start,
                        style: timeStyle,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(BuildContext context, DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }

    final localTime = dateTime.toLocal();
    final timeOfDay = TimeOfDay.fromDateTime(localTime);
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(
      timeOfDay,
      alwaysUse24HourFormat: false,
    );
  }
}
