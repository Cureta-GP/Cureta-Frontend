import 'dart:async';

import 'package:cureta/core/Services/notification_service.dart';
import 'package:cureta/features/home/data/models/schedule_entry.dart';
import 'package:cureta/features/home/data/schedule_builder.dart';
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
    return ScheduleBuilder.buildForDate(
      repository: _medicineRepository,
      medicines: medicines,
      date: DateTime.now(),
    );
  }

  @override
  Future<void> close() async {
    await _medicinesSub?.cancel();
    await _alarmActionsSub?.cancel();
    return super.close();
  }
}
