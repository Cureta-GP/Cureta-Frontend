import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/theme_extensions.dart';
import '../veiw_model/chat_cubit.dart';
import '../veiw_model/chat_sessions_cubit.dart';
import '../veiw_model/chat_sessions_state.dart';
import '../veiw_model/chat_state.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message.dart';
import '../widgets/chat_message_list.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatCubit>.value(value: getIt.get<ChatCubit>()),
        BlocProvider<ChatSessionsCubit>.value(
          value: getIt.get<ChatSessionsCubit>()..fetchSessions(),
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

class _ChatScreenBodyState extends State<_ChatScreenBody> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _getAppLanguage(BuildContext context) {
    final locale = context.locale;
    if (locale.languageCode == 'ar') return 'Egyptian Arabic';
    return 'English';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colors.chatBackground,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Sessions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: BlocBuilder<ChatSessionsCubit, ChatSessionsState>(
                  builder: (context, state) {
                    if (state is ChatSessionsLoading) {
                      return const Center(child: CircularProgressIndicator());
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
                        return const Center(child: Text('No sessions yet'));
                      }

                      return ListView.separated(
                        itemCount: state.sessions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final session = state.sessions[index];
                          return ListTile(
                            title: Text(session.title),
                            subtitle: Text(
                              session.createdAt.toLocal().toString(),
                            ),
                            onTap: () {
                              context.read<ChatCubit>().loadMessages(
                                sessionId: session.id,
                              );
                              Navigator.of(context).pop();
                            },
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
              onMenu: () {
                context.read<ChatSessionsCubit>().fetchSessions();
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatMessagesLoaded) {
                    final messages = state.messages
                        .map(
                          (message) => ChatMessage(
                            text: message.content,
                            isUser: message.role == 'user',
                          ),
                        )
                        .toList();
                    return ChatMessageList(messages: messages);
                  }

                  if (state is ChatLoading) {
                    final messages = state.messages
                        .map(
                          (message) => ChatMessage(
                            text: message.content,
                            isUser: message.role == 'user',
                          ),
                        )
                        .toList();

                    return Column(
                      children: [
                        Expanded(child: ChatMessageList(messages: messages)),
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    );
                  }

                  if (state is ChatError) {
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

                  return ChatMessageList(
                    messages: [
                      ChatMessage(
                        text: AppLocalizations.chatGreetingMessage,
                        isUser: false,
                      ),
                    ],
                  );
                },
              ),
            ),
            ChatInputBar(
              onSend: (message) {
                final state = context.read<ChatCubit>().state;
                String? sessionId;
                if (state is ChatMessagesLoaded) sessionId = state.sessionId;
                if (state is ChatLoading) sessionId = state.sessionId;
                context.read<ChatCubit>().sendMessage(
                  text: message,
                  appLanguage: _getAppLanguage(context),
                  sessionId: sessionId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
