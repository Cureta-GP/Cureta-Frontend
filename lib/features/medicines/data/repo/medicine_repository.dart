import 'dart:developer' as developer;
import 'package:uuid/uuid.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import '../models/dose_log_model.dart';
import '../models/medicine_model.dart';
import '../models/dose_log_model.dart';
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

  Future<MedicineModel?> getMedicineById(String localId) async {
    return await _local.getById(localId);
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
        if (m.remoteId != null && m.remoteId!.isNotEmpty) {
          // It's an update
          await _remote.updateMedicine(m.remoteId!, _buildPayload(m, pid));
          await _local.updateSyncStatus(m.id, SyncStatus.synced);
        } else {
          // It's a create
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
        }
      } catch (e) {
        developer.log('Failed to sync medicine ${m.id}: $e', name: 'MedicineRepository');
        await _local.updateSyncStatus(m.id, SyncStatus.failed);
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

  Future<MedicineModel> updateMedicine(MedicineModel m) async { 
    final updating = m.copyWith(syncStatus: SyncStatus.pending);
    await _local.update(updating); 
    if (updating.remoteId != null && updating.remoteId!.isNotEmpty) {
      try {
        final pid = await _pid();
        await _remote.updateMedicine(updating.remoteId!, _buildPayload(updating, pid));
        final synced = updating.copyWith(syncStatus: SyncStatus.synced);
        await _local.update(synced);
        return synced;
      } catch (e) {
        developer.log('Failed to update medicine on remote: $e', name: 'MedicineRepository');
        final failed = updating.copyWith(syncStatus: SyncStatus.failed);
        await _local.update(failed);
        return failed;
      }
    }
    return updating; 
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

  Future<void> logMedicationAction(
    String localId,
    String status, {
    String? remoteId,
    DateTime? scheduledAt,
  }) async {
    final m = await _local.getById(localId);
    final now = DateTime.now();
    final normalizedStatus = status.trim().toUpperCase();
    String? effectiveRemoteId = remoteId;

    if (m != null) {
      await _local.update(m.copyWith(updatedAt: now));
      if (m.remoteId != null && m.remoteId!.isNotEmpty) {
        effectiveRemoteId = m.remoteId;
      }
    }

    if (effectiveRemoteId != null && effectiveRemoteId.isNotEmpty) {
      try {
        developer.log(
          'Sending dose log: localId=$localId, remoteId=$effectiveRemoteId, status=$normalizedStatus',
          name: 'MedicineRepository',
        );
        await _remote.trackDose(
          effectiveRemoteId,
          normalizedStatus,
          scheduledAt: scheduledAt,
        );
        developer.log(
          'Dose log sent successfully for remoteId=$effectiveRemoteId',
          name: 'MedicineRepository',
        );
      } catch (e) {
        developer.log('Failed to log dose: $e', name: 'MedicineRepository');
      }
    } else {
      developer.log(
        'Skip remote dose log: no remoteId found (localId=$localId)',
        name: 'MedicineRepository',
      );
    }
  }

  Future<List<DoseLogModel>> getMedicineLogs(String localId) async {
    try {
      final pid = await _pid();
      if (pid.isEmpty) return [];
      
      final m = await _local.getById(localId);
      if (m == null || m.remoteId == null || m.remoteId!.isEmpty) return [];

      return await _remote.getProfileLogs(
        profileId: pid,
        medicineId: m.remoteId,
      );
    } catch (e) {
      developer.log('Failed to fetch medicine logs for $localId: $e', name: 'MedicineRepository');
      return [];
    }
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
