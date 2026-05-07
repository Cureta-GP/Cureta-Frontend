import 'package:cureta/core/Services/dio_helper.dart';
import 'package:cureta/core/constants/api_endpoints.dart';
import '../models/medicine_dto.dart';
import '../models/medicine_payload.dart';
import '../models/dose_log_model.dart';

class MedicineService {
  MedicineService();
  Future<MedicineDto> createMedicine(MedicinePayload payload) async {
    final response = await DioHelper.postData(
      url: ApiEndpoints.medicines,
      data: payload.toJson(),
    );
    return MedicineDto.fromJson(_extractItemMap(response.data));
  }

  Future<List<MedicineDto>> getMedicines({
    required String profileId,
    String? status,
  }) async {
    final query = <String, dynamic>{
      'profile_id': profileId,
      if (status != null && status.isNotEmpty) 'status': status,
    };
    final response = await DioHelper.getData(
      url: ApiEndpoints.medicines,
      query: query,
    );
    return _extractItemsList(
      response.data,
    ).map((e) => MedicineDto.fromJson(e)).toList();
  }

  Future<MedicineDto> getMedicineById(String id) async {
    final response = await DioHelper.getData(
      url: ApiEndpoints.medicineData(id),
      query: {},
    );
    return MedicineDto.fromJson(_extractItemMap(response.data));
  }

  Future<MedicineDto> updateMedicine(String id, MedicinePayload payload) async {
    final data = payload.toJson();
    data.remove('reminders');
    final response = await DioHelper.putData(
      url: ApiEndpoints.medicineData(id),
      data: data,
    );
    return MedicineDto.fromJson(_extractItemMap(response.data));
  }

  Future<MedicineDto> archiveMedicine(String id) async {
    final response = await DioHelper.patchData(
      url: ApiEndpoints.medicineArchive(id),
      query: {},
      data: {},
    );
    return MedicineDto.fromJson(_extractItemMap(response.data));
  }

  Future<void> deleteMedicine(String id) async {
    await DioHelper.deleteData(url: ApiEndpoints.medicineData(id));
  }

  Future<void> trackDose(
    String medicineId,
    String status, {
    DateTime? scheduledAt,
  }) async {
    final scheduled =
        (scheduledAt ?? DateTime.now()).toUtc().toIso8601String();
    await DioHelper.postData(
      url: ApiEndpoints.medicineLogs(medicineId),
      data: {'status': status, 'scheduled_at': scheduled},
    );
  }

  Future<List<DoseLogModel>> getProfileLogs({
    required String profileId,
    String? medicineId,
    String? status,
    String? fromDate,
    String? toDate,
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, dynamic>{
      if (medicineId != null && medicineId.isNotEmpty) 'medicine_id': medicineId,
      if (status != null && status.isNotEmpty) 'status': status,
      if (fromDate != null && fromDate.isNotEmpty) 'from_date': fromDate,
      if (toDate != null && toDate.isNotEmpty) 'to_date': toDate,
      'page': page,
      'limit': limit,
    };
    final response = await DioHelper.getData(
      url: ApiEndpoints.profileLogs(profileId),
      query: query,
    );
    return _extractItemsList(response.data)
        .map((e) => DoseLogModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> _extractItemMap(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final data = raw['data'];
      if (data is Map<String, dynamic>) return data;
      return raw;
    }
    return const <String, dynamic>{};
  }

  List<Map<String, dynamic>> _extractItemsList(dynamic raw) {
    if (raw is List) {
      return raw.whereType<Map<String, dynamic>>().toList();
    }
    if (raw is! Map<String, dynamic>) {
      return const <Map<String, dynamic>>[];
    }

    final directData = raw['data'];
    if (directData is List) {
      return directData.whereType<Map<String, dynamic>>().toList();
    }
    if (directData is Map<String, dynamic>) {
      final nestedItems = directData['items'] ?? directData['medicines'];
      if (nestedItems is List) {
        return nestedItems.whereType<Map<String, dynamic>>().toList();
      }
    }

    final topItems = raw['items'] ?? raw['medicines'];
    if (topItems is List) {
      return topItems.whereType<Map<String, dynamic>>().toList();
    }

    return const <Map<String, dynamic>>[];
  }
}
