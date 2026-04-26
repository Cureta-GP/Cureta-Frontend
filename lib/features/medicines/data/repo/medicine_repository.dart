import 'dart:developer' as developer;
import 'package:uuid/uuid.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import '../models/medicine_model.dart';
import '../models/medicine_payload.dart';
import '../models/medicine_enums.dart';
import '../services/medicine_local_service.dart';
import '../services/medicine_service.dart';

class MedicineRepository {
  final MedicineLocalService _localService;
  final MedicineService _remoteService;
  final ProfileRepository? _profileRepo;
  final Uuid _uuid = const Uuid();

  MedicineRepository({
    required MedicineLocalService localService,
    required MedicineService remoteService,
    ProfileRepository? profileRepo,
  }) : _localService = localService,
       _remoteService = remoteService,
       _profileRepo = profileRepo;

  Future<String> _getProfileId() async {
    final profileRepo = _profileRepo ?? getIt<ProfileRepository>();
    return await profileRepo.getResolvedSelectedProfileId() ?? '';
  }

  Future<MedicineModel> addMedicine(MedicinePayload payload) async {
    final localId = _uuid.v4();
    final now = DateTime.now();
    final localModel = MedicineModel(
      id: localId,
      name: payload.name,
      doseForm: payload.doseForm ?? DoseForm.pill,
      doseAmount: _extractDoseAmount(payload.dose),
      doseUnit: _extractDoseUnit(payload.dose),
      frequency: payload.frequency,
      alarmTimes: payload.reminders,
      startDate: DateTime.tryParse(payload.startDate) ?? now,
      notes: payload.notes,
      isActive: true,
      syncStatus: SyncStatus.pending,
      createdAt: now,
      updatedAt: now,
    );

    await _localService.insert(localModel);

    // Add profileId to payload before sending to API
    final payloadWithProfile = MedicinePayload(
      profileId: await _getProfileId(),
      name: payload.name,
      dose: payload.dose,
      frequency: payload.frequency,
      reminders: payload.reminders,
      startDate: payload.startDate,
      endDate: payload.endDate,
      notes: payload.notes,
      doseForm: payload.doseForm,
    );

    try {
      final remoteDto = await _remoteService.createMedicine(payloadWithProfile);
      await _localService.updateSyncStatus(
        localId,
        SyncStatus.synced,
        remoteId: remoteDto.id,
      );
      return localModel.copyWith(
        syncStatus: SyncStatus.synced,
        remoteId: remoteDto.id,
      );
    } catch (e) {
      developer.log(
        'Failed to sync medicine $localId to server: $e',
        name: 'MedicineRepository',
      );
      return localModel;
    }
  }

  Future<List<MedicineModel>> getUserMedicines() async {
    final local = await _localService.getAll();
    _refreshFromRemote().ignore();
    return local;
  }

  Future<void> _refreshFromRemote() async {
    final profileId = await _getProfileId();
    if (profileId.isEmpty) return;

    try {
      final dtos = await _remoteService.getMedicines(profileId: profileId);
      for (final dto in dtos) {
        final existing = await _localService.getById(dto.id ?? '');
        if (existing != null) {
          final updated = dto.toDomain(
            existing.id,
            syncStatus: SyncStatus.synced,
            remoteId: dto.id,
          );
          await _localService.update(updated);
        } else {
          final newId = _uuid.v4();
          final model = dto.toDomain(
            newId,
            syncStatus: SyncStatus.synced,
            remoteId: dto.id,
          );
          await _localService.insert(model);
        }
      }
    } catch (e) {
      developer.log(
        'Failed to refresh medicines from server: $e',
        name: 'MedicineRepository',
      );
    }
  }

  Future<void> syncPendingMedicines() async {
    final profileId = await _getProfileId();
    if (profileId.isEmpty) return;

    final pending = await _localService.getPending();
    for (final medicine in pending) {
      try {
        final payload = _buildPayload(medicine, profileId);
        final dto = await _remoteService.createMedicine(payload);
        await _localService.updateSyncStatus(
          medicine.id,
          SyncStatus.synced,
          remoteId: dto.id,
        );
      } catch (e) {
        developer.log(
          'Failed to sync medicine ${medicine.id}: $e',
          name: 'MedicineRepository',
        );
      }
    }
  }

  Future<void> deleteMedicine(String localId) async {
    final medicine = await _localService.getById(localId);
    await _localService.delete(localId);

    if (medicine != null && medicine.remoteId != null) {
      try {
        await _remoteService.deleteMedicine(medicine.remoteId!);
      } catch (e) {
        developer.log(
          'Failed to delete medicine ${medicine.remoteId} from server: $e',
          name: 'MedicineRepository',
        );
      }
    }
  }

  Future<MedicineModel> updateMedicine(MedicineModel medicine) async {
    await _localService.update(medicine);
    return medicine;
  }

  Future<void> toggleMedicineActive(String localId) async {
    final medicine = await _localService.getById(localId);
    if (medicine == null) return;

    final updated = medicine.copyWith(
      isActive: !medicine.isActive,
      updatedAt: DateTime.now(),
    );
    await _localService.update(updated);
  }

  MedicinePayload _buildPayload(MedicineModel model, [String? profileId]) {
    final dose = model.doseAmount.isNotEmpty && model.doseUnit.isNotEmpty
        ? '${model.doseAmount} ${model.doseUnit}'
        : model.doseAmount.isNotEmpty
        ? model.doseAmount
        : model.doseUnit;

    return MedicinePayload(
      profileId: profileId,
      name: model.name,
      dose: dose,
      frequency: model.frequency,
      reminders: model.alarmTimes,
      startDate: model.startDate.toIso8601String(),
      notes: model.notes,
    );
  }

  String _extractDoseAmount(String dose) {
    if (dose.isEmpty) return '';
    final regex = RegExp(r'^([\d.]+)\s*(.*)$');
    final match = regex.firstMatch(dose.trim());
    return match?.group(1) ?? '';
  }

  String _extractDoseUnit(String dose) {
    if (dose.isEmpty) return '';
    final regex = RegExp(r'^([\d.]+)\s*(.*)$');
    final match = regex.firstMatch(dose.trim());
    return match?.group(2)?.trim() ?? '';
  }
}
