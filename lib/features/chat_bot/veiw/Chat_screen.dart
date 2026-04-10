import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/theme_extensions.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message.dart';
import '../widgets/chat_message_list.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  List<ChatMessage> _sampleMessages() {
    return [
      ChatMessage(text: AppLocalizations.chatGreetingMessage, isUser: false),
      ChatMessage(text: AppLocalizations.chatUserQuestion, isUser: true),
      ChatMessage(text: AppLocalizations.chatReplyMessage, isUser: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.chatBackground,
      body: SafeArea(
        child: Column(
          children: [
            ChatHeader(onClose: () => Navigator.of(context).pop()),
            Expanded(child: ChatMessageList(messages: _sampleMessages())),
            ChatInputBar(onSend: () {}),
          ],
        ),
      ),
    );
  }
}
