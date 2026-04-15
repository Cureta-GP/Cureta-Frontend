import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

class InMemoryChatController
    with UploadProgressMixin, ScrollToMessageMixin
    implements ChatController {
  final _operations = StreamController<ChatOperation>.broadcast();
  final List<Message> _messages = <Message>[];

  @override
  List<Message> get messages => List.unmodifiable(_messages);

  @override
  Stream<ChatOperation> get operationsStream => _operations.stream;

  @override
  Future<void> insertMessage(
    Message message, {
    int? index,
    bool animated = true,
  }) async {
    debugPrint('[CHAT_CONTROLLER] insertMessage id=${message.id}');
    if (_messages.any((current) => current.id == message.id)) {
      debugPrint('[CHAT_CONTROLLER] insert skipped duplicate id=${message.id}');
      return;
    }

    _messages.add(message);
    _messages.sort(
      (a, b) => (a.createdAt?.millisecondsSinceEpoch ?? 0).compareTo(
        b.createdAt?.millisecondsSinceEpoch ?? 0,
      ),
    );

    final insertionIndex = _messages.indexOf(message);
    debugPrint(
      '[CHAT_CONTROLLER] insert at index=$insertionIndex | total=${_messages.length}',
    );
    _operations.add(
      ChatOperation.insert(message, insertionIndex, animated: animated),
    );
  }

  @override
  Future<void> removeMessage(Message message, {bool animated = true}) async {
    final index = _messages.indexWhere((current) => current.id == message.id);
    if (index == -1) {
      return;
    }

    final removed = _messages.removeAt(index);
    _operations.add(ChatOperation.remove(removed, index, animated: animated));
  }

  @override
  Future<void> updateMessage(Message oldMessage, Message newMessage) async {
    final index = _messages.indexWhere(
      (current) => current.id == oldMessage.id,
    );
    if (index == -1) {
      return;
    }

    if (_messages[index] == newMessage) {
      return;
    }

    final actual = _messages[index];
    _messages[index] = newMessage;
    _operations.add(ChatOperation.update(actual, newMessage, index));
  }

  @override
  Future<void> setMessages(
    List<Message> messages, {
    bool animated = true,
  }) async {
    debugPrint('[CHAT_CONTROLLER] setMessages count=${messages.length}');
    _messages
      ..clear()
      ..addAll(messages);
    _operations.add(ChatOperation.set(messages, animated: animated));
  }

  @override
  Future<void> insertAllMessages(
    List<Message> messages, {
    int? index,
    bool animated = true,
  }) async {
    if (messages.isEmpty) {
      return;
    }

    final originalLength = _messages.length;
    _messages.addAll(messages);
    _messages.sort(
      (a, b) => (a.createdAt?.millisecondsSinceEpoch ?? 0).compareTo(
        b.createdAt?.millisecondsSinceEpoch ?? 0,
      ),
    );

    _operations.add(
      ChatOperation.insertAll(messages, originalLength, animated: animated),
    );
  }

  @override
  void dispose() {
    _operations.close();
    disposeUploadProgress();
    disposeScrollMethods();
  }
}
