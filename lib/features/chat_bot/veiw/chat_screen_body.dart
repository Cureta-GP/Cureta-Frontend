import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/auto_scroll_mixin.dart';
import '../veiw_model/chat_cubit.dart';
import '../veiw_model/chat_sessions_cubit.dart';
import '../veiw_model/chat_state.dart';
import '../widgets/chat_screen_content.dart';
import '../widgets/chat_sessions_drawer.dart';

class ChatScreenBody extends StatefulWidget {
  const ChatScreenBody({super.key});

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody>
    with AutoScrollMixin<ChatScreenBody> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _inputController = TextEditingController();
  bool _isCallbackWired = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isCallbackWired) return;
    context.read<ChatCubit>().onMessageInserted = onIncomingContent;
    _isCallbackWired = true;
  }

  @override
  void dispose() {
    _inputController.dispose();
    disposeAutoScroll();
    super.dispose();
  }

  void _sendMessage(String message) {
    enableAutoScroll();
    scheduleScrollToBottom(smooth: true);
    final appLanguage =
        context.locale.languageCode == 'ar' ? 'Egyptian Arabic' : 'English';
    unawaited(
      context.read<ChatCubit>().sendTextMessage(
        message,
        appLanguage: appLanguage,
      ),
    );
  }

  void _startNewChat(ChatState state) {
    Navigator.of(context).pop();
    if (state.isEmpty) return;
    enableAutoScroll();
    _inputController.clear();
    unawaited(context.read<ChatCubit>().startNewChat());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final media = MediaQuery.of(context);
        final compact = media.viewInsets.bottom > 0 &&
            media.orientation == Orientation.landscape;
        return Scaffold(
          key: _scaffoldKey,
          drawer: ChatSessionsDrawer(
            onNewChat: () => _startNewChat(state),
          ),
          body: ChatScreenContent(
            compact: compact,
            chatState: state,
            inputController: _inputController,
            scrollController: scrollController,
            isUserScrolledAway: isUserScrolledAway,
            onScrollNotification: handleScrollNotification,
            onSend: _sendMessage,
            onJumpToBottom: jumpToBottom,
            onOpenMenu: () {
              context.read<ChatSessionsCubit>().fetchSessions();
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        );
      },
    );
  }
}
