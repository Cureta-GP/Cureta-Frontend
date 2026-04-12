import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import '../models/chat_session_model.dart';
import '../models/chat_message_model.dart';
import '../models/send_message_request.dart';
import '../models/send_message_response.dart';
import '../services/chat_service.dart';

class ChatRepository {
  final ChatService _service;
  ChatRepository(this._service);
  Future<List<ChatSessionModel>> fetchSessions({
    required String profileId,
  }) async {
    try {
      final response = await _service.getSessions(profileId: profileId);

      final data = response.data['data'] as List<dynamic>?;
      if (data == null) return [];

      return data
          .map((e) => ChatSessionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<ChatMessageModel>> fetchMessages({
    required String sessionId,
  }) async {
    try {
      final response = await _service.getMessages(sessionId: sessionId);

      final data = response.data['data'] as List<dynamic>?;
      if (data == null) return [];

      return data
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<SendMessageResponse> sendMessage({
    required SendMessageRequest request,
  }) async {
    try {
      final response = await _service.sendMessage(data: request);

      final responseData = response.data['data'];
      if (responseData == null || responseData is! Map<String, dynamic>) {
        throw AppException.server(msg: 'Invalid response format');
      }

      return SendMessageResponse.fromJson(responseData);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
