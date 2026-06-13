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

      final data = response.data;
      if (data is List) {
        return data.map((e) => e.toString()).toList();
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
      return response.data['token'];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to generate QR share token',
      );
    }
  }

  Future<String> redeemToken(String token) async {
    try {
      final response = await _service.redeemToken(token);
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Failed to redeem QR share token',
      );
    }
  }
}
