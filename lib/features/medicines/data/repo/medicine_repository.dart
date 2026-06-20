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
  }) : _local = localService,
       _remote = remoteService,
       _profileRepo = profileRepo;

  Future<String> _pid() async {
    final repo = _profileRepo ?? getIt<ProfileRepository>();
    return await repo.getResolvedSelectedProfileId() ?? '';
  }

  Future<MedicineModel> addMedicine(MedicinePayload payload) async {
    final pid = await _pid();
    final now = DateTime.now();
    final model = MedicineModel(
      id: _uuid.v4(),
      profileId: pid,
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
      imagePath: payload.imagePath,
    );
    await _local.insert(model);
    try {
      final dto = await _remote.createMedicine(
        MedicinePayload(
          profileId: pid,
          name: payload.name,
          dose: payload.dose,
          frequency: payload.frequency,
          reminders: payload.reminders,
          startDate: payload.startDate,
          endDate: payload.endDate,
          notes: payload.notes,
          doseForm: payload.doseForm,
        ),
      );
      if (dto.id != null && dto.id!.isNotEmpty) {
        await _local.updateSyncStatus(
          model.id,
          SyncStatus.synced,
          remoteId: dto.id,
        );
        return model.copyWith(syncStatus: SyncStatus.synced, remoteId: dto.id);
      }
      await _refreshFromRemote(pid);
      final linked = await _local.getById(model.id);
      if (linked != null &&
          linked.remoteId != null &&
          linked.remoteId!.isNotEmpty) {
        return linked;
      }
      await _local.updateSyncStatus(model.id, SyncStatus.failed);
      return model.copyWith(syncStatus: SyncStatus.failed);
    } catch (e) {
      developer.log(
        'Failed to sync medicine ${model.id}: $e',
        name: 'MedicineRepository',
      );
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
        final model = dto.toDomain(
          _uuid.v4(),
          syncStatus: SyncStatus.synced,
          remoteId: dto.id,
          profileId: pid,
        );
        await _local.upsertFromRemote(model);
      }
    } catch (e) {
      developer.log(
        'Failed to refresh medicines: $e',
        name: 'MedicineRepository',
      );
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
          final dto = await _remote.updateMedicine(m.remoteId!, _buildPayload(m, pid));
          final newRemoteId = (dto.id != null && dto.id!.isNotEmpty) ? dto.id : m.remoteId;
          await _local.updateSyncStatus(m.id, SyncStatus.synced, remoteId: newRemoteId);
        } else {
          // It's a create
          final dto = await _remote.createMedicine(_buildPayload(m, pid));
          if (dto.id != null && dto.id!.isNotEmpty) {
            await _local.updateSyncStatus(
              m.id,
              SyncStatus.synced,
              remoteId: dto.id,
            );
            continue;
          }
          await _refreshFromRemote(pid);
          final linked = await _local.getById(m.id);
          if (linked == null ||
              linked.remoteId == null ||
              linked.remoteId!.isEmpty) {
            await _local.updateSyncStatus(m.id, SyncStatus.failed);
          }
        }
      } catch (e) {
        developer.log(
          'Failed to sync medicine ${m.id}: $e',
          name: 'MedicineRepository',
        );
        await _local.updateSyncStatus(m.id, SyncStatus.failed);
      }
    }
  }

  Future<void> deleteMedicine(String localId) async {
    final m = await _local.getById(localId);
    await _local.delete(localId);
    if (m?.remoteId != null) {
      try {
        await _remote.deleteMedicine(m!.remoteId!);
      } catch (e) {
        developer.log(
          'Failed to delete medicine: $e',
          name: 'MedicineRepository',
        );
      }
    }
  }

  Future<MedicineModel> updateMedicine(MedicineModel m) async {
    final updating = m.copyWith(syncStatus: SyncStatus.pending);
    await _local.update(updating);
    
    if (updating.remoteId != null && updating.remoteId!.isNotEmpty) {
      try {
        try {
          final pid = await _pid();
        
        // Normalize startDate to beginning of day to avoid timezone/time validation issues on backend
        DateTime normalizedStart = updating.startDate;
        if (normalizedStart.hour != 0 || normalizedStart.minute != 0 || normalizedStart.second != 0) {
          normalizedStart = DateTime(normalizedStart.year, normalizedStart.month, normalizedStart.day);
        }

        String computedDose = updating.doseAmount.isNotEmpty && updating.doseUnit.isNotEmpty
            ? '${updating.doseAmount} ${updating.doseUnit}'
            : updating.doseAmount.isNotEmpty
            ? updating.doseAmount
            : updating.doseUnit;

        if (computedDose.trim().isEmpty) {
          computedDose = '1'; // Fallback dose to pass backend validation
        }

        final payload = MedicinePayload(
          profileId: pid,
          name: updating.name,
          dose: computedDose,
          frequency: updating.frequency,
          reminders: updating.alarmTimes,
          startDate: normalizedStart.toIso8601String(),
          notes: updating.notes,
          doseForm: updating.doseForm,
        );

        // 1. Fetch current reminders directly from the dedicated endpoints using medicine ID
        // This is safe and guarantees we have the true IDs, bypassing the stale main GET /api/medicines
        final oldReminders = updating.remoteId != null && updating.remoteId!.isNotEmpty 
            ? await _remote.getReminders(updating.remoteId!) 
            : [];
        
        // 2. Update the main medicine details
        final dto = await _remote.updateMedicine(
          updating.remoteId!,
          payload,
        );

        // 3. Diffing logic for reminders (Positional Matching to use PUT for edits)
        final newTimes = payload.reminders;
        
        developer.log('DIFFING: oldReminders from server = $oldReminders', name: 'MedicineRepository');
        developer.log('DIFFING: newTimes from UI = $newTimes', name: 'MedicineRepository');
        
        final maxLength = oldReminders.length > newTimes.length ? oldReminders.length : newTimes.length;
        
        for (int i = 0; i < maxLength; i++) {
          final oldReminder = i < oldReminders.length ? oldReminders[i] : null;
          final newTime = i < newTimes.length ? newTimes[i] : null;
          
          if (oldReminder != null && newTime != null) {
            // Both exist at this index -> Update using PUT
            final existingId = oldReminder['id']?.toString() ?? oldReminder['reminder_id']?.toString();
            developer.log('DIFFING: Updating index $i. existingId = $existingId, newTime = $newTime', name: 'MedicineRepository');
            if (existingId != null && existingId.isNotEmpty) {
              await _remote.updateReminder(existingId, payload, newTime);
            }
          } else if (oldReminder != null && newTime == null) {
            // Old exists, new doesn't -> Delete
            final oldId = oldReminder['id']?.toString() ?? oldReminder['reminder_id']?.toString();
            developer.log('DIFFING: Deleting index $i. oldId = $oldId', name: 'MedicineRepository');
            if (oldId != null && oldId.isNotEmpty) {
              await _remote.deleteReminder(oldId);
            }
          } else if (oldReminder == null && newTime != null) {
            // New exists, old doesn't -> Create using POST
            developer.log('DIFFING: Creating new reminder at index $i. newTime = $newTime', name: 'MedicineRepository');
            await _remote.createReminder(updating.remoteId!, payload, newTime);
          }
        }

        final serverRemoteId =
            (dto.id != null && dto.id!.isNotEmpty) ? dto.id : updating.remoteId;
        final remoteModel = dto.toDomain(
          updating.id,
          syncStatus: SyncStatus.synced,
          remoteId: serverRemoteId,
          profileId: updating.profileId,
        );
        final synced = updating.copyWith(
          syncStatus: SyncStatus.synced,
          remoteId: serverRemoteId,
          // Keep local-only fields while trusting backend canonical medicine fields.
          name: remoteModel.name,
          doseAmount: remoteModel.doseAmount.isNotEmpty
              ? remoteModel.doseAmount
              : updating.doseAmount,
          doseUnit: remoteModel.doseUnit.isNotEmpty
              ? remoteModel.doseUnit
              : updating.doseUnit,
          frequency: remoteModel.frequency,
          notes: remoteModel.notes,
          alarmTimes: updating.alarmTimes, // Always trust local updated times since backend PUT ignores them
          startDate: remoteModel.startDate,
          updatedAt: DateTime.now().add(const Duration(seconds: 5)), // HACK: Protect against stale GET /api/medicines that overwrite local DB
        );
        await _local.update(synced);
        return synced;
      } catch (e) {
        developer.log('Failed to update medicine on remote: $e', name: 'MedicineRepository');
        final failed = updating.copyWith(syncStatus: SyncStatus.failed);
        await _local.update(failed);
        
        // Re-throw so the Cubit knows the exact reason!
        throw Exception(e.toString());
      }
    } catch (e) {
      developer.log('Critical error in updateMedicine: $e', name: 'MedicineRepository');
      rethrow;
    }
    }
    // For pending creations, fallback to basic update.
    await _local.update(updating);
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
        throw Exception('Failed to save log to server: $e');
      }
    } else {
      developer.log(
        'Skip remote dose log: no remoteId found (localId=$localId)',
        name: 'MedicineRepository',
      );
      throw Exception('Cannot log dose: Medicine not synced with server');
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
      developer.log(
        'Failed to fetch medicine logs for $localId: $e',
        name: 'MedicineRepository',
      );
      return [];
    }
  }

  MedicinePayload _buildPayload(MedicineModel m, String pid) {
    // Normalize startDate to beginning of day to avoid timezone/time validation issues on backend
    DateTime normalizedStart = m.startDate;
    if (normalizedStart.hour != 0 || normalizedStart.minute != 0 || normalizedStart.second != 0) {
      normalizedStart = DateTime(normalizedStart.year, normalizedStart.month, normalizedStart.day);
    }

    String computedDose = m.doseAmount.isNotEmpty && m.doseUnit.isNotEmpty
        ? '${m.doseAmount} ${m.doseUnit}'
        : m.doseAmount.isNotEmpty
        ? m.doseAmount
        : m.doseUnit;

    if (computedDose.trim().isEmpty) {
      computedDose = '1'; // Fallback dose to pass backend validation
    }

    return MedicinePayload(
      profileId: pid,
      name: m.name,
      dose: computedDose,
      frequency: m.frequency,
      reminders: m.alarmTimes,
      startDate: normalizedStart.toIso8601String(),
      notes: m.notes,
      doseForm: m.doseForm,
    );
  }

  String _extractDoseAmount(String dose) {
    if (dose.isEmpty) return '';
    return RegExp(r'^([\d.]+)\s*(.*)$').firstMatch(dose.trim())?.group(1) ?? '';
  }

  String _extractDoseUnit(String dose) {
    if (dose.isEmpty) return '';
    return RegExp(
          r'^([\d.]+)\s*(.*)$',
        ).firstMatch(dose.trim())?.group(2)?.trim() ??
        '';
  }
}
