import 'dart:math' as math;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:shimmer/shimmer.dart';

import '../veiw_model/chat_cubit.dart';
import 'chat_empty_state.dart';
import 'scroll_to_bottom_fab.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({
    super.key,
    required this.cubit,
    required this.isReplyLoading,
    required this.isHistoryLoading,
    required this.isEmpty,
    required this.scrollController,
    required this.isUserScrolledAway,
    required this.onScrollNotification,
    this.onMessageSend,
    required this.onAttachmentTap,
    required this.onJumpToBottom,
  });

  final ChatCubit cubit;
  final bool isReplyLoading;
  final bool isHistoryLoading;
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
    final typingIndicatorBottomSpace = isReplyLoading ? 58.0 : 0.0;
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
                  reversed: true,
                  physics: const ClampingScrollPhysics(),
                  scrollController: scrollController,
                  itemBuilder: itemBuilder,
                  topPadding: 2,
                  bottomPadding: typingIndicatorBottomSpace,
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
        if (isReplyLoading)
          const Positioned(
            left: 10,
            bottom: 12,
            child: _TypingIndicatorBubble(),
          ),
        if (isHistoryLoading)
          const Positioned.fill(child: _HistoryLoadingShimmer()),
        if (isEmpty && !isHistoryLoading) const ChatEmptyState(),
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
    final textScaler = MediaQuery.textScalerOf(context);
    final baseFontSize =
        baseTextStyle.fontSize ??
        DefaultTextStyle.of(context).style.fontSize ??
        14;
    final messageTextStyle = baseTextStyle.copyWith(
      fontSize: textScaler.scale(baseFontSize + 1.5),
    );
    final timeStyle = (textTheme.labelSmall ?? const TextStyle()).copyWith(
      color: messageForeground.withValues(alpha: 0.78),
      decoration: TextDecoration.none,
    );
    final shouldAnimate = !isSentByMe && (message.metadata?['animate'] == true);
    final messageDirection = _resolveTextDirection(context, message.text);
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
      style: messageTextStyle,
      textScaler: TextScaler.noScaling,
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
            textStyle: messageTextStyle,
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
      textDirection: messageDirection,
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

  TextDirection _resolveTextDirection(BuildContext context, String text) {
    final content = text.trim();
    if (content.isEmpty) {
      return Directionality.of(context);
    }

    final arabicMatch = RegExp(r'[\u0600-\u06FF]').firstMatch(content);
    final latinMatch = RegExp(r'[A-Za-z]').firstMatch(content);

    if (arabicMatch == null && latinMatch != null) {
      return TextDirection.ltr;
    }

    if (latinMatch == null && arabicMatch != null) {
      return TextDirection.rtl;
    }

    if (arabicMatch != null && latinMatch != null) {
      return latinMatch.start < arabicMatch.start
          ? TextDirection.ltr
          : TextDirection.rtl;
    }

    return Directionality.of(context);
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

class _TypingIndicatorBubble extends StatefulWidget {
  const _TypingIndicatorBubble();

  @override
  State<_TypingIndicatorBubble> createState() => _TypingIndicatorBubbleState();
}

class _TypingIndicatorBubbleState extends State<_TypingIndicatorBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final phase = (_controller.value + (index * 0.2)) % 1.0;
                final wave = math.sin(phase * 2 * math.pi).abs();
                final opacity = 0.32 + (wave * 0.68);
                final scale = 0.72 + (wave * 0.28);

                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: Container(
                width: 7,
                height: 7,
                margin: EdgeInsetsDirectional.only(end: index == 2 ? 0 : 5),
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _HistoryLoadingShimmer extends StatelessWidget {
  const _HistoryLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final bubbleBase = colorScheme.surface;
    final highlight = colorScheme.outlineVariant.withValues(alpha: 0.35);
    const widthPattern = <double>[0.88, 0.72, 0.94, 0.66, 0.82, 0.76];
    const linePattern = <int>[2, 3, 2, 2, 3, 2];
    return IgnorePointer(
      child: ColoredBox(
        color: theme.scaffoldBackgroundColor,
        child: Shimmer.fromColors(
          baseColor: bubbleBase,
          highlightColor: highlight,
          period: const Duration(milliseconds: 1300),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const estimatedTileHeight = 94.0;
              final itemCount =
                  ((constraints.maxHeight / estimatedTileHeight).ceil() + 2)
                      .clamp(6, 14);

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 24),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final isUser = index.isOdd;
                  return _ShimmerMessageBubble(
                    isUser: isUser,
                    widthFactor: widthPattern[index % widthPattern.length],
                    lineCount: linePattern[index % linePattern.length],
                    bubbleColor: bubbleBase,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ShimmerMessageBubble extends StatelessWidget {
  const _ShimmerMessageBubble({
    required this.isUser,
    required this.widthFactor,
    required this.lineCount,
    required this.bubbleColor,
  });

  final bool isUser;
  final double widthFactor;
  final int lineCount;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) {
    final borderRadius = isUser
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

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 * widthFactor,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < lineCount; i++) ...[
                  FractionallySizedBox(
                    widthFactor: _lineWidthFactor(i),
                    child: Container(
                      height: 11,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  if (i != lineCount - 1) const SizedBox(height: 6),
                ],
                const SizedBox(height: 8),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Container(
                    width: 44,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _lineWidthFactor(int index) {
    switch (index) {
      case 0:
        return 1;
      case 1:
        return 0.86;
      default:
        return 0.64;
    }
  }
}
