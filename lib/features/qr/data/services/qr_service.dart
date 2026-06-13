import 'package:cureta/core/Services/dio_helper.dart';
import 'package:cureta/core/constants/api_endpoints.dart';
import 'package:cureta/features/qr/data/models/qr_share_token_request.dart';
import 'package:dio/dio.dart';

class QrService {
  Future<Response> getRecordsCategories({String? profileId}) async {
    try {
      final response = await DioHelper.getData(
        url: ApiEndpoints.recordsCategories,
        query: {'profileId': profileId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> generateToken(QrShareTokenRequest request) async {
    try {
      final response = await DioHelper.postData(
        url: ApiEndpoints.filteredRecords,
        data: request.toJson(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> redeemToken(String token) async {
    try {
      final response = await DioHelper.getData(
        url: ApiEndpoints.qrShare(token),
        query: {},
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
