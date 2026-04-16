import 'dart:async';
import 'dart:ui';

import 'package:cureta/core/Services/GetItServices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../utils/auto_scroll_mixin.dart';
import '../veiw_model/chat_cubit.dart';
import '../veiw_model/chat_sessions_cubit.dart';
import '../veiw_model/chat_sessions_state.dart';
import '../veiw_model/chat_state.dart';
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
    if (locale.languageCode == 'ar') {
      return 'Egyptian Arabic';
    }
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

  void _handleNewChat(ChatState chatState) {
    if (chatState.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    enableAutoScroll();
    _inputController.clear();
    unawaited(context.read<ChatCubit>().startNewChat());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, chatState) {
        final chatBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            backgroundColor: chatBackgroundColor,
            child: SafeArea(
              child: ColoredBox(
                color: chatBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.locale.languageCode == 'ar'
                                  ? 'المحادثات'
                                  : 'Sessions',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () => _handleNewChat(chatState),
                            icon: const Icon(
                              Icons.add_comment_outlined,
                              size: 18,
                            ),
                            label: Text(
                              context.locale.languageCode == 'ar'
                                  ? 'محادثة جديدة'
                                  : 'New Chat',
                            ),
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
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
                              addAutomaticKeepAlives: false, // لا تحتفظ تلقائيًا بالحالة
                              addRepaintBoundaries: false, // قلل إنشاء الطبقات الزائدة
                               cacheExtent: 250, // مسافة التحميل المسبق
                               physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                              itemCount: state.sessions.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
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

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5.5,
                                      sigmaY: 5.5,
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () {
                                          context
                                              .read<ChatCubit>()
                                              .loadMessages(
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
                                            color: colorScheme.surface
                                                .withValues(alpha: 0.72),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: colorScheme.shadow
                                                    .withValues(alpha: 0.10),
                                                blurRadius: 16,
                                                offset: const Offset(0, 6),
                                              ),
                                              BoxShadow(
                                                color: colorScheme.primary
                                                    .withValues(alpha: 0.06),
                                                blurRadius: 12,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ],
                                          ),
                                        ),
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
