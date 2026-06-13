import 'dart:async';

import 'package:cureta/core/Services/notification_service.dart';
import 'package:cureta/features/home/data/models/schedule_entry.dart';
import 'package:cureta/features/medicines/data/models/dose_log_model.dart';
import 'package:cureta/features/medicines/data/models/medicine_model.dart';
import 'package:cureta/features/medicines/data/repo/medicine_repository.dart';
import 'package:cureta/features/home/view_model/home_schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScheduleCubit extends Cubit<HomeScheduleState> {
  HomeScheduleCubit(this._medicineRepository)
    : super(const HomeScheduleInitial());

  final MedicineRepository _medicineRepository;
  StreamSubscription<List<MedicineModel>>? _medicinesSub;
  StreamSubscription<void>? _alarmActionsSub;
  String? _activeProfileId;
  bool _isLoading = false;

  Future<void> startAutoRefresh(String profileId) async {
    if (_activeProfileId == profileId &&
        _medicinesSub != null &&
        _alarmActionsSub != null) {
      return;
    }
    _activeProfileId = profileId;
    await _medicinesSub?.cancel();
    _medicinesSub = _medicineRepository.watchUserMedicines().listen((
      medicines,
    ) async {
      final entries = await _buildTodayEntries(medicines);
      emit(HomeScheduleLoaded(entries));
    });
    await _alarmActionsSub?.cancel();
    _alarmActionsSub = NotificationService.instance.alarmActionsSynced.listen((
      _,
    ) async {
      final pid = _activeProfileId;
      if (pid == null) return;
      await _refreshSilently(pid);
    });
    await load(profileId);
  }

  Future<void> load(String profileId) async {
    if (_isLoading) return;
    _isLoading = true;
    emit(const HomeScheduleLoading());
    try {
      await NotificationService.instance.syncPendingAlarmActions();
      await _medicineRepository.refreshMedicines();
      final medicines = await _medicineRepository.getUserMedicines();
      final entries = await _buildTodayEntries(medicines);
      emit(HomeScheduleLoaded(entries));
    } catch (e) {
      emit(HomeScheduleError(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  /// Call after user marks a dose — just reload
  Future<void> refresh(String profileId) => load(profileId);

  Future<void> _refreshSilently(String profileId) async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      await NotificationService.instance.syncPendingAlarmActions();
      await _medicineRepository.refreshMedicines();
      final medicines = await _medicineRepository.getUserMedicines();
      final entries = await _buildTodayEntries(medicines);
      emit(HomeScheduleLoaded(entries));
    } catch (_) {
      // Silent refresh must never interrupt UI with transient errors.
    } finally {
      _isLoading = false;
    }
  }

  Future<List<ScheduleEntry>> _buildTodayEntries(
    List<MedicineModel> medicines,
  ) async {
    final now = DateTime.now();
    final activeMedicines = medicines
        .where((m) => m.isActive && !m.isPaused && m.alarmTimes.isNotEmpty)
        .toList();

    final entries = <ScheduleEntry>[];

    for (final medicine in activeMedicines) {
      final logs = await _medicineRepository.getMedicineLogs(medicine.id);

      for (final alarm in medicine.alarmTimes) {
        final scheduled = _todayAt(alarm, now);
        if (scheduled == null) continue;

        final status = _resolveStatus(scheduled, logs, now);

        entries.add(
          ScheduleEntry(
            medicineId: medicine.id,
            name: medicine.name,
            scheduledAt: scheduled,
            status: status,
          ),
        );
      }
    }

    entries.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return entries;
  }

  DoseStatus _resolveStatus(
    DateTime scheduled,
    List<DoseLogModel> logs,
    DateTime now,
  ) {
    final matchingLogs = logs.where((log) {
      final localScheduled = log.scheduledAt.toLocal();
      final localTaken = log.takenAt?.toLocal();
      final byScheduled = _isLikelySameDoseSlot(localScheduled, scheduled);
      final byTaken = localTaken != null
          ? _isLikelySameDoseSlot(localTaken, scheduled)
          : false;
      return byScheduled || byTaken;
    });

    if (matchingLogs.any((l) => l.status.name == 'taken')) {
      return DoseStatus.taken;
    }

    if (matchingLogs.any((l) => l.status.name == 'missed')) {
      return DoseStatus.missed;
    }

    return scheduled.isBefore(now) ? DoseStatus.missed : DoseStatus.pending;
  }

  bool _isLikelySameDoseSlot(DateTime a, DateTime b) {
    // Robust match for timezone/seconds drift while avoiding cross-day false matches.
    final sameLocalDay =
        a.year == b.year && a.month == b.month && a.day == b.day;
    if (!sameLocalDay) return false;
    final diff = a.difference(b).inMinutes.abs();
    return diff <= 90;
  }

  DateTime? _todayAt(String hhmm, DateTime now) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
      return null;
    }
    return DateTime(now.year, now.month, now.day, h, m);
  }

  @override
  Future<void> close() async {
    await _medicinesSub?.cancel();
    await _alarmActionsSub?.cancel();
    return super.close();
  }
}
