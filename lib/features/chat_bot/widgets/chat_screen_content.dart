import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme_extensions.dart';
import '../veiw_model/chat_cubit.dart';
import '../veiw_model/chat_state.dart';
import 'chat_body.dart';
import 'chat_header.dart';
import 'chat_input_bar.dart';

class ChatScreenContent extends StatelessWidget {
  const ChatScreenContent({
    super.key,
    required this.compact,
    required this.chatState,
    required this.inputController,
    required this.scrollController,
    required this.isUserScrolledAway,
    required this.onScrollNotification,
    required this.onSend,
    required this.onJumpToBottom,
    required this.onOpenMenu,
  });

  final bool compact;
  final ChatState chatState;
  final TextEditingController inputController;
  final ScrollController scrollController;
  final bool isUserScrolledAway;
  final bool Function(ScrollNotification) onScrollNotification;
  final ValueChanged<String> onSend;
  final VoidCallback onJumpToBottom;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColoredBox(
        color: context.colors.chatBackground,
        child: Column(
          children: [
            if (!compact)
              ChatHeader(isLoading: chatState.isReplyLoading, onMenu: onOpenMenu),
            Expanded(
              child: ChatBody(
                cubit: context.read<ChatCubit>(),
                isReplyLoading: chatState.isReplyLoading,
                isHistoryLoading: chatState.isHistoryLoading,
                isEmpty: chatState.isEmpty,
                scrollController: scrollController,
                isUserScrolledAway: isUserScrolledAway,
                onScrollNotification: onScrollNotification,
                onMessageSend: null,
                onAttachmentTap: null,
                onJumpToBottom: onJumpToBottom,
              ),
            ),
            ChatInputBar(
              controller: inputController,
              compactMode: compact,
              isLoading: chatState.isLoading,
              onSend: onSend,
              onAttach: null,
              onMic: null,
            ),
          ],
        ),
      ),
    );
  }
}
