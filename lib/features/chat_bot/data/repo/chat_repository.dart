import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:flutter/foundation.dart';
import '../models/chat_session_model.dart';
import '../models/chat_message_model.dart';
import '../models/send_message_request.dart';
import '../models/send_message_response.dart';
import '../services/chat_service.dart';

class ChatRepository {
  final ChatService _service;
  ChatRepository(this._service);

  void _log(String message) {
    debugPrint('[CHAT_REPO] $message');
  }

  Future<List<ChatSessionModel>> fetchSessions({
    required String profileId,
  }) async {
    try {
      _log('fetchSessions request | profileId=$profileId');
      final response = await _service.getSessions(profileId: profileId);
      _log('fetchSessions raw response: ${jsonEncode(response.data)}');

      final data = _extractList(response.data, fallbackKey: 'sessions');
      if (data == null) {
        _log('fetchSessions no list found in payload');
        return [];
      }

      final result = data
          .map((e) => ChatSessionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _log('fetchSessions parsed count=${result.length}');
      return result;
    } catch (e) {
      _log('fetchSessions error: $e');
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<ChatMessageModel>> fetchMessages({
    required String sessionId,
  }) async {
    try {
      _log('fetchMessages request | sessionId=$sessionId');
      final response = await _service.getMessages(sessionId: sessionId);
      _log('fetchMessages raw response: ${jsonEncode(response.data)}');

      final data = _extractList(response.data, fallbackKey: 'messages');
      if (data == null) {
        _log('fetchMessages no list found in payload');
        return [];
      }

      final result = data
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _log('fetchMessages parsed count=${result.length}');
      return result;
    } catch (e) {
      _log('fetchMessages error: $e');
      throw ErrorHandler.handle(e);
    }
  }

  Future<SendMessageResponse> sendMessage({
    required SendMessageRequest request,
  }) async {
    try {
      _log('sendMessage request payload: ${jsonEncode(request.toJson())}');
      final response = await _service.sendMessage(data: request);
      _log('sendMessage raw response: ${jsonEncode(response.data)}');

      final responseData = _extractMap(response.data, fallbackKey: 'message');
      if (responseData == null) {
        _log('sendMessage invalid response map');
        throw AppException.server(msg: 'Invalid response format');
      }

      final parsed = SendMessageResponse.fromJson(responseData);
      _log(
        'sendMessage parsed | sessionId=${parsed.sessionId} | answerLen=${parsed.answer.length}',
      );
      return parsed;
    } on DioException catch (error) {
      _log('sendMessage dio error: $error');

      if (_isTransientModelOverload(error)) {
        _log('sendMessage retrying once due to transient model overload');
        try {
          final retryResponse = await _service.sendMessage(data: request);
          _log(
            'sendMessage retry raw response: ${jsonEncode(retryResponse.data)}',
          );

          final retryData = _extractMap(
            retryResponse.data,
            fallbackKey: 'message',
          );
          if (retryData == null) {
            throw AppException.server(msg: 'Invalid response format');
          }

          final parsed = SendMessageResponse.fromJson(retryData);
          _log(
            'sendMessage retry parsed | sessionId=${parsed.sessionId} | answerLen=${parsed.answer.length}',
          );
          return parsed;
        } on DioException catch (retryError) {
          _log('sendMessage retry dio error: $retryError');
          throw _mapSendMessageException(retryError);
        }
      }

      throw _mapSendMessageException(error);
    } on AppException {
      rethrow;
    } catch (e) {
      _log('sendMessage error: $e');
      throw ErrorHandler.handle(e);
    }
  }

  AppException _mapSendMessageException(DioException error) {
    final data = error.response?.data;
    final details = data is Map ? data['details']?.toString() ?? '' : '';
    final message = data is Map ? data['message']?.toString() ?? '' : '';

    final detailsLower = details.toLowerCase();
    if (detailsLower.contains('service unavailable') ||
        detailsLower.contains('high demand') ||
        detailsLower.contains('generativelanguage.googleapis.com')) {
      return AppException.server(
        msg:
            'The AI assistant is currently busy. Please try again in a few moments.',
      );
    }

    if (message.isNotEmpty) {
      return AppException.server(msg: message);
    }

    return ErrorHandler.handle(error);
  }

  bool _isTransientModelOverload(DioException error) {
    final data = error.response?.data;
    final details = data is Map ? data['details']?.toString() ?? '' : '';
    final detailsLower = details.toLowerCase();

    return error.response?.statusCode == 500 &&
        (detailsLower.contains('service unavailable') ||
            detailsLower.contains('high demand') ||
            detailsLower.contains('503'));
  }

  List<dynamic>? _extractList(dynamic body, {required String fallbackKey}) {
    if (body is List<dynamic>) {
      return body;
    }

    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is List<dynamic>) {
        return data;
      }

      final fallback = body[fallbackKey];
      if (fallback is List<dynamic>) {
        return fallback;
      }
    }

    return null;
  }

  Map<String, dynamic>? _extractMap(
    dynamic body, {
    required String fallbackKey,
  }) {
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }

      final fallback = body[fallbackKey];
      if (fallback is Map<String, dynamic>) {
        return fallback;
      }

      return body;
    }

    return null;
  }
}
