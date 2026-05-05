import 'dart:developer' as developer;
import 'package:uuid/uuid.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import '../models/dose_log_model.dart';
import '../models/medicine_model.dart';
import '../models/medicine_payload.dart';
import '../models/medicine_enums.dart';
import '../services/medicine_local_service.dart';
import '../services/medicine_service.dart';

class MedicineRepository {
  final MedicineLocalService _local;
  final MedicineService _remote;
  final ProfileRepository? _profileRepo;
  final Uuid _uuid = const Uuid();

  MedicineRepository({
    required MedicineLocalService localService,
    required MedicineService remoteService,
    ProfileRepository? profileRepo,
  })  : _local = localService, _remote = remoteService, _profileRepo = profileRepo;

  Future<String> _pid() async {
    final repo = _profileRepo ?? getIt<ProfileRepository>();
    return await repo.getResolvedSelectedProfileId() ?? '';
  }

  Future<MedicineModel> addMedicine(MedicinePayload payload) async {
    final pid = await _pid();
    final now = DateTime.now();
    final model = MedicineModel(
      id: _uuid.v4(), profileId: pid, name: payload.name,
      doseForm: payload.doseForm ?? DoseForm.pill,
      doseAmount: _extractDoseAmount(payload.dose), doseUnit: _extractDoseUnit(payload.dose),
      frequency: payload.frequency, alarmTimes: payload.reminders,
      startDate: DateTime.tryParse(payload.startDate) ?? now,
      notes: payload.notes, isActive: true, syncStatus: SyncStatus.pending,
      createdAt: now, updatedAt: now, imagePath: payload.imagePath,
    );
    await _local.insert(model);
    try {
      final dto = await _remote.createMedicine(MedicinePayload(
        profileId: pid, name: payload.name, dose: payload.dose,
        frequency: payload.frequency, reminders: payload.reminders,
        startDate: payload.startDate, endDate: payload.endDate,
        notes: payload.notes, doseForm: payload.doseForm,
      ));
      if (dto.id != null && dto.id!.isNotEmpty) {
        await _local.updateSyncStatus(model.id, SyncStatus.synced, remoteId: dto.id);
        return model.copyWith(syncStatus: SyncStatus.synced, remoteId: dto.id);
      }
      await _refreshFromRemote(pid);
      final linked = await _local.getById(model.id);
      if (linked != null && linked.remoteId != null && linked.remoteId!.isNotEmpty) return linked;
      await _local.updateSyncStatus(model.id, SyncStatus.failed);
      return model.copyWith(syncStatus: SyncStatus.failed);
    } catch (e) {
      developer.log('Failed to sync medicine ${model.id}: $e', name: 'MedicineRepository');
      return model;
    }
  }

  Future<List<MedicineModel>> getUserMedicines() async {
    final pid = await _pid();
    final local = await _local.getAll(pid);
    _refreshFromRemote(pid).ignore();
    return local;
  }

  Stream<List<MedicineModel>> watchUserMedicines() async* {
    final pid = await _pid();
    yield* _local.watchAll(pid);
  }

  Future<void> refreshMedicines() async => _refreshFromRemote(await _pid());

  Future<void> _refreshFromRemote(String pid) async {
    if (pid.isEmpty) return;
    try {
      for (final dto in await _remote.getMedicines(profileId: pid)) {
        if (dto.id == null || dto.id!.isEmpty) continue;
        final model = dto.toDomain(_uuid.v4(), syncStatus: SyncStatus.synced, remoteId: dto.id, profileId: pid);
        await _local.upsertFromRemote(model);
      }
    } catch (e) {
      developer.log('Failed to refresh medicines: $e', name: 'MedicineRepository');
    }
  }

  Future<void> syncPendingMedicines() async {
    final pid = await _pid();
    if (pid.isEmpty) return;
    await _refreshFromRemote(pid);
    for (final m in await _local.getPending(pid)) {
      try {
        final dto = await _remote.createMedicine(_buildPayload(m, pid));
        if (dto.id != null && dto.id!.isNotEmpty) {
          await _local.updateSyncStatus(m.id, SyncStatus.synced, remoteId: dto.id);
          continue;
        }
        await _refreshFromRemote(pid);
        final linked = await _local.getById(m.id);
        if (linked == null || linked.remoteId == null || linked.remoteId!.isEmpty) {
          await _local.updateSyncStatus(m.id, SyncStatus.failed);
        }
      } catch (e) {
        developer.log('Failed to sync medicine ${m.id}: $e', name: 'MedicineRepository');
      }
    }
  }

  Future<void> deleteMedicine(String localId) async {
    final m = await _local.getById(localId);
    await _local.delete(localId);
    if (m?.remoteId != null) {
      try { await _remote.deleteMedicine(m!.remoteId!); }
      catch (e) { developer.log('Failed to delete medicine: $e', name: 'MedicineRepository'); }
    }
  }

  Future<MedicineModel> updateMedicine(MedicineModel m) async { await _local.update(m); return m; }

  Future<MedicineModel?> getMedicineById(String localId) async {
    return _local.getById(localId);
  }

  Future<void> toggleMedicineActive(String localId) async {
    final m = await _local.getById(localId);
    if (m == null) return;
    await _local.update(
      m.copyWith(
        isActive: !m.isActive,
        isPaused: false,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> setMedicineActive(String localId, bool isActive) async {
    final m = await _local.getById(localId);
    if (m == null) return;
    await _local.update(
      m.copyWith(
        isActive: isActive,
        isPaused: isActive ? m.isPaused : false,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> setMedicinePaused(String localId, bool isPaused) async {
    final m = await _local.getById(localId);
    if (m == null) return;
    await _local.update(
      m.copyWith(
        isPaused: isPaused,
        isActive: isPaused ? true : m.isActive,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> logMedicationAction(String localId, String status) async {
    final m = await _local.getById(localId);
    if (m == null) return;
    final now = DateTime.now();
    await _local.update(m.copyWith(updatedAt: now));
    final statusLower = status.toLowerCase();
    final parsedStatus = DoseStatus.values.firstWhere(
      (e) => e.name == statusLower,
      orElse: () => DoseStatus.pending,
    );
    final log = DoseLogModel(
      id: _uuid.v4(),
      medicineId: m.id,
      scheduledAt: now,
      status: parsedStatus,
      takenAt: parsedStatus == DoseStatus.taken ? now : null,
      remoteId: m.remoteId,
    );
    await _local.insertDoseLog({
      ...log.toJson(),
      'created_at': now.toIso8601String(),
    });
    if (m.remoteId != null && m.remoteId!.isNotEmpty) {
      try {
        await _remote.trackDose(m.remoteId!, status);
      } catch (e) {
        developer.log('Failed to log dose: $e', name: 'MedicineRepository');
      }
    }
  }

  Future<List<DoseLogModel>> getDoseLogs(String localId) async {
    final rows = await _local.getDoseLogs(localId);
    return rows.map(DoseLogModel.fromJson).toList();
  }

  MedicinePayload _buildPayload(MedicineModel m, String pid) => MedicinePayload(
    profileId: pid, name: m.name,
    dose: m.doseAmount.isNotEmpty && m.doseUnit.isNotEmpty ? '${m.doseAmount} ${m.doseUnit}'
        : m.doseAmount.isNotEmpty ? m.doseAmount : m.doseUnit,
    frequency: m.frequency, reminders: m.alarmTimes,
    startDate: m.startDate.toIso8601String(), notes: m.notes,
  );

  String _extractDoseAmount(String dose) {
    if (dose.isEmpty) return '';
    return RegExp(r'^([\d.]+)\s*(.*)$').firstMatch(dose.trim())?.group(1) ?? '';
  }

  String _extractDoseUnit(String dose) {
    if (dose.isEmpty) return '';
    return RegExp(r'^([\d.]+)\s*(.*)$').firstMatch(dose.trim())?.group(2)?.trim() ?? '';
  }
}
