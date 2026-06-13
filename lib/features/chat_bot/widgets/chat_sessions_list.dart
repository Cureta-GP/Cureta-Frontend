import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme_extensions.dart';
import '../data/models/chat_session_model.dart';
import '../veiw_model/chat_cubit.dart';
import 'chat_session_tile.dart';

class ChatSessionsList extends StatelessWidget {
  const ChatSessionsList({super.key, required this.sessions});

  final List<ChatSessionModel> sessions;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      final text = context.locale.languageCode == 'ar'
          ? 'لا توجد محادثات بعد'
          : 'No sessions yet';
      return Center(child: Text(text));
    }

    final spacing = context.spacing;
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing.md,
        spacing.xs,
        spacing.md,
        spacing.lg,
      ),
      itemCount: sessions.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return ChatSessionTile(
          title: _displaySessionTitle(context, session.title, index),
          dateText: _formatSessionDate(context, session.createdAt),
          onTap: () {
            context.read<ChatCubit>().loadMessages(sessionId: session.id);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  String _displaySessionTitle(BuildContext context, String title, int index) {
    final trimmed = title.trim();
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

  bool _looksLikeSessionId(String value) {
    final uuid = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
    );
    final hex = RegExp(r'^[a-fA-F0-9]{20,}$');
    final token = RegExp(r'^[a-zA-Z0-9_-]{18,}$');
    return uuid.hasMatch(value) || hex.hasMatch(value) || token.hasMatch(value);
  }
}
