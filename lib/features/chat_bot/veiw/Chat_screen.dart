import 'dart:async';

import 'package:cureta/core/Services/GetItServices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../veiw_model/chat_cubit.dart';
import '../veiw_model/chat_sessions_cubit.dart';
import '../veiw_model/chat_sessions_state.dart';
import '../veiw_model/chat_state.dart';
import '../utils/auto_scroll_mixin.dart';
import '../widgets/chat_body.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatCubit>(create: (_) => getIt.get<ChatCubit>()),
        BlocProvider<ChatSessionsCubit>(
          create: (_) => getIt.get<ChatSessionsCubit>(),
        ),
      ],
      child: const _ChatScreenBody(),
    );
  }
}

class _ChatScreenBody extends StatefulWidget {
  const _ChatScreenBody();

  @override
  State<_ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<_ChatScreenBody>
    with AutoScrollMixin<_ChatScreenBody> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _inputController = TextEditingController();
  bool _wiredScrollCallback = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_wiredScrollCallback) {
      return;
    }

    context.read<ChatCubit>().onMessageInserted = onIncomingContent;
    _wiredScrollCallback = true;
  }

  @override
  void dispose() {
    _inputController.dispose();
    disposeAutoScroll();
    super.dispose();
  }

  String _getAppLanguage(BuildContext context) {
    final locale = context.locale;
    if (locale.languageCode == 'ar') return 'Egyptian Arabic';
    return 'English';
  }

  bool _looksLikeSessionId(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return true;
    }

    final uuidPattern = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
    );
    final hexLikePattern = RegExp(r'^[a-fA-F0-9]{20,}$');
    final tokenLikePattern = RegExp(r'^[a-zA-Z0-9_-]{18,}$');

    return uuidPattern.hasMatch(normalized) ||
        hexLikePattern.hasMatch(normalized) ||
        tokenLikePattern.hasMatch(normalized);
  }

  String _displaySessionTitle(
    BuildContext context,
    String rawTitle,
    int index,
  ) {
    final trimmed = rawTitle.trim();
    if (trimmed.isEmpty || _looksLikeSessionId(trimmed)) {
      return context.locale.languageCode == 'ar'
          ? 'محادثة ${index + 1}'
          : 'Chat ${index + 1}';
    }

    return trimmed;
  }

  String _formatSessionDate(BuildContext context, DateTime createdAt) {
    final localeName = context.locale.toString();
    return DateFormat.yMMMd(localeName).add_jm().format(createdAt.toLocal());
  }

  void _handleSend(String message) {
    enableAutoScroll();
    scheduleScrollToBottom(smooth: true);
    unawaited(
      context.read<ChatCubit>().sendTextMessage(
        message,
        appLanguage: _getAppLanguage(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, chatState) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      context.locale.languageCode == 'ar'
                          ? 'المحادثات'
                          : 'Sessions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<ChatSessionsCubit, ChatSessionsState>(
                      builder: (context, state) {
                        if (state is ChatSessionsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is ChatSessionsError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                state.error.message,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        if (state is ChatSessionsSuccess) {
                          if (state.sessions.isEmpty) {
                            return Center(
                              child: Text(
                                context.locale.languageCode == 'ar'
                                    ? 'لا توجد محادثات بعد'
                                    : 'No sessions yet',
                              ),
                            );
                          }

                          final colorScheme = Theme.of(context).colorScheme;
                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                            itemCount: state.sessions.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final session = state.sessions[index];
                              final title = _displaySessionTitle(
                                context,
                                session.title,
                                index,
                              );
                              final dateText = _formatSessionDate(
                                context,
                                session.createdAt,
                              );

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    context.read<ChatCubit>().loadMessages(
                                      sessionId: session.id,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: Ink(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: colorScheme.outlineVariant
                                            .withValues(alpha: 0.45),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: colorScheme.primary
                                                .withValues(alpha: 0.14),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.chat_bubble_outline,
                                            size: 18,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                dateText,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return const Center(child: Text('No sessions yet'));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                ChatHeader(
                  isLoading: chatState.isReplyLoading,
                  onMenu: () {
                    context.read<ChatSessionsCubit>().fetchSessions();
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                Expanded(
                  child: ChatBody(
                    cubit: context.read<ChatCubit>(),
                    isReplyLoading: chatState.isReplyLoading,
                    isHistoryLoading: chatState.isHistoryLoading,
                    isEmpty: chatState.isEmpty,
                    scrollController: scrollController,
                    isUserScrolledAway: isUserScrolledAway,
                    onScrollNotification: handleScrollNotification,
                    onMessageSend: null,
                    onAttachmentTap: null,
                    onJumpToBottom: jumpToBottom,
                  ),
                ),
                ChatInputBar(
                  controller: _inputController,
                  isLoading: chatState.isLoading,
                  onSend: _handleSend,
                  onAttach: null,
                  onMic: null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
