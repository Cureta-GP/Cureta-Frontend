import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme_extensions.dart';
import '../veiw_model/chat_sessions_cubit.dart';
import '../veiw_model/chat_sessions_state.dart';
import 'chat_sessions_list.dart';

class ChatSessionsDrawer extends StatelessWidget {
  const ChatSessionsDrawer({super.key, required this.onNewChat});

  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final typography = context.typography;

    return Drawer(
      backgroundColor: context.colors.chatBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                spacing.lg,
                spacing.lg,
                spacing.lg,
                spacing.xs,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.locale.languageCode == 'ar'
                          ? 'المحادثات'
                          : 'Sessions',
                      style: typography.title,
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: onNewChat,
                    icon: const Icon(Icons.add_comment_outlined),
                    label: Text(
                      context.locale.languageCode == 'ar'
                          ? 'محادثة جديدة'
                          : 'New Chat',
                    ),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: spacing.md,
                        vertical: spacing.xs,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.xs * 0.25),
            Expanded(
              child: BlocBuilder<ChatSessionsCubit, ChatSessionsState>(
                builder: (context, state) {
                  if (state is ChatSessionsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ChatSessionsError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.lg),
                        child: Text(
                          state.error.message,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  if (state is ChatSessionsSuccess) {
                    return ChatSessionsList(sessions: state.sessions);
                  }
                  final text = context.locale.languageCode == 'ar'
                      ? 'لا توجد محادثات بعد'
                      : 'No sessions yet';
                  return Center(child: Text(text));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
