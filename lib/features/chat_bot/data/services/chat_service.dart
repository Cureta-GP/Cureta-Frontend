import 'package:dio/dio.dart';
import 'package:cureta/core/Services/dio_helper.dart';
import '../models/send_message_request.dart';

class ChatService {
  Future<Response> getSessions({required String profileId}) async {
    return await DioHelper.getData(url: 'chats/profile/$profileId', query: {});
  }

  Future<Response> getMessages({required String sessionId}) async {
    return await DioHelper.getData(url: 'chats/session/$sessionId/messages', query: {});
  }

  Future<Response> sendMessage({required SendMessageRequest data}) async {
    return await DioHelper.postData(url: 'chat', data: data.toJson());
  }
}
