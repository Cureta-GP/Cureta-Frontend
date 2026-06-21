import 'dart:convert';

import 'package:cureta/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:cureta/features/qr/data/services/qr_service.dart';
import 'package:cureta/features/qr/data/models/qr_share_token_request.dart';

class QrRepository {
  final QrService _service;

  QrRepository(this._service);

  Future<List<String>> getRecordsCategories({String? profileId}) async {
    try {
      final response = await _service.getRecordsCategories(
        profileId: profileId,
      );

      final body = response.data;

      if (body is Map<String, dynamic>) {
        final inner = body['data'];

        if (inner is Map<String, dynamic> && inner['categories'] is List) {
          return (inner['categories'] as List)
              .map((e) => e.toString())
              .toList();
        }

        // fallback لو الـ structure مختلف في حالات تانية
        if (inner is List) {
          return inner.map((e) => e.toString()).toList();
        }
      }

      if (body is List) {
        return body.map((e) => e.toString()).toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to fetch record categories',
      );
    }
  }

  Future<String> generateToken(QrShareTokenRequest request) async {
    try {
      final response = await _service.generateToken(request);
      final data = response.data;

      if (data is Map<String, dynamic>) {
        final token = data['token'] ?? data['data']?['token'];
        if (token is String && token.isNotEmpty) return token;
      }

      if (data is String && data.isNotEmpty) return data;

      throw Exception('Invalid QR token response from backend');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to generate QR share token',
      );
    }
  }

  Future<String> redeemToken(String token) async {
    try {
      final response = await _service.redeemToken(token);
      final data = response.data;

      if (data is String && data.isNotEmpty) return data;
      if (data is Map<String, dynamic>) return jsonEncode(data);

      return data.toString();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to redeem QR share token',
      );
    }
  }

  Future<String> generateShareUrl(QrShareTokenRequest request) async {
    try {
      final response = await _service.generateToken(request);
      final body = response.data;

      if (body is Map<String, dynamic>) {
        final inner = body['data'];

        if (inner is Map<String, dynamic>) {
          final shareUrl = inner['share_url'] as String?;
          if (shareUrl != null && shareUrl.isNotEmpty) {
            return shareUrl;
          }
        }
      }

      throw Exception('Invalid QR share response from backend');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to generate QR share link',
      );
    }
  }
}
