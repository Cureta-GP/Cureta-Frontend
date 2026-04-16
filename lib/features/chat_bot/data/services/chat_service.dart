import 'package:dio/dio.dart';
import 'package:cureta/core/Services/dio_helper.dart';
import 'package:flutter/foundation.dart';
import '../models/send_message_request.dart';

class ChatService {
  void _log(String message) {
    debugPrint('[CHAT_SERVICE] $message');
  }

  Future<Response> getSessions({required String profileId}) async {
    _log('GET chats/profile/$profileId');
    final response = await DioHelper.getData(
      url: 'chats/profile/$profileId',
      query: {},
    );
    _log('GET chats/profile/$profileId -> status=${response.statusCode}');
    return response;
  }

  Future<Response> getMessages({required String sessionId}) async {
    _log('GET chats/session/$sessionId/messages');
    final response = await DioHelper.getData(
      url: 'chats/session/$sessionId/messages',
      query: {},
    );
    _log(
      'GET chats/session/$sessionId/messages -> status=${response.statusCode}',
    );
    return response;
  }

  Future<Response> sendMessage({required SendMessageRequest data}) async {
    _log('POST chat');
    final response = await DioHelper.postData(url: 'chat', data: data.toJson());
    _log('POST chat -> status=${response.statusCode}');
    return response;
  }
}
