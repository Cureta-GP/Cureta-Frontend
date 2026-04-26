import 'package:cureta/core/Services/dio_helper.dart';
import 'package:cureta/core/constants/api_endpoints.dart';
import '../models/medicine_dto.dart';
import '../models/medicine_payload.dart';

class MedicineService {
  MedicineService();

  Future<MedicineDto> createMedicine(MedicinePayload payload) async {
    final response = await DioHelper.postData(
      url: ApiEndpoints.medicines,
      data: payload.toJson(),
    );
    return MedicineDto.fromJson(response.data as Map<String, dynamic>);
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
    final data = response.data;
    if (data is List) {
      return data
          .map((e) => MedicineDto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map<String, dynamic> && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => MedicineDto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<MedicineDto> getMedicineById(String id) async {
    final response = await DioHelper.getData(
      url: ApiEndpoints.medicineData(id),
      query: {},
    );
    return MedicineDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<MedicineDto> updateMedicine(String id, MedicinePayload payload) async {
    final response = await DioHelper.putData(
      url: ApiEndpoints.medicineData(id),
      data: payload.toJson(),
    );
    return MedicineDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<MedicineDto> archiveMedicine(String id) async {
    final response = await DioHelper.patchData(
      url: ApiEndpoints.medicineArchive(id),
      query: {},
      data: {},
    );
    return MedicineDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteMedicine(String id) async {
    await DioHelper.deleteData(url: ApiEndpoints.medicineData(id));
  }

  Future<MedicineDto> trackDose(
    String medicineId,
    Map<String, dynamic> payload,
  ) async {
    final response = await DioHelper.postData(
      url: ApiEndpoints.medicineLogs(medicineId),
      data: payload,
    );
    return MedicineDto.fromJson(response.data as Map<String, dynamic>);
  }
}