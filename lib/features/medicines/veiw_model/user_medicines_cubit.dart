import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/Services/notification_service.dart';
import '../data/models/medicine_model.dart';
import '../data/models/medicine_enums.dart';
import '../data/repo/medicine_repository.dart';
import 'user_medicines_state.dart';

class UserMedicinesCubit extends Cubit<UserMedicinesState> {
  final MedicineRepository _repository;
  StreamSubscription<List<MedicineModel>>? _medicinesSubscription;
  List<MedicineModel> _allMedicines = [];
  List<MedicineModel> _filteredMedicines = [];
  bool? _currentFilter;
  String _currentSearch = '';
  bool _didInitialAlarmSync = false;

  UserMedicinesCubit(this._repository) : super(const UserMedicinesInitial());

  Future<void> init() async {
    await _medicinesSubscription?.cancel();
    _medicinesSubscription = _repository.watchUserMedicines().listen(
      (medicines) {
        _allMedicines = medicines;
        _applyFilters();
        if (!_didInitialAlarmSync) {
          _rescheduleActiveAlarms();
          _didInitialAlarmSync = true;
        }
      },
      onError: (_) {
        emit(
          const UserMedicinesError(
            messageKey: 'medicines.error_loading_medicines',
          ),
        );
      },
    );

    _refreshThenSync().ignore();
  }

  Future<void> _refreshThenSync() async {
    await _repository.refreshMedicines();
    await syncPendingMedicines();
  }

  void _rescheduleActiveAlarms() {
    final activeMedicines = _allMedicines.where(
      (m) => m.isActive && !m.isPaused && m.alarmTimes.isNotEmpty,
    );
    for (final medicine in activeMedicines) {
      NotificationService.instance.scheduleMedicineAlarms(medicine).ignore();
    }
  }

  Future<void> loadMedicines() async {
    final currentState = state;
    final hasData =
        currentState is UserMedicinesLoaded ||
        currentState is UserMedicinesSyncBanner;

    // Only show spinner when the list is genuinely empty.
    // If we already have data, let the stream update it silently.
    if (!hasData) {
      emit(const UserMedicinesLoading());
    }

    try {
      await _repository.refreshMedicines();
      await syncPendingMedicines();
    } catch (e) {
      // Only show error if there is no data to display.
      if (!hasData) {
        emit(
          const UserMedicinesError(
            messageKey: 'medicines.error_loading_medicines',
          ),
        );
      }
    }
  }

  Future<void> syncPendingMedicines() async {
    try {
      await _repository.syncPendingMedicines();
      final pendingCount = _allMedicines
          .where((m) => m.syncStatus == SyncStatus.pending)
          .length;
      if (pendingCount > 0) {
        final failedCount = _allMedicines
            .where((m) => m.syncStatus == SyncStatus.failed)
            .length;
        if (failedCount > 0 && state is UserMedicinesLoaded) {
          emit(
            UserMedicinesSyncBanner(
              failedCount: failedCount,
              previousState: state as UserMedicinesLoaded,
            ),
          );
        }
      }
    } catch (e) {
      // Background sync failure is non-blocking
    }
  }

  Future<void> deleteMedicine(String localId) async {
    final currentState = state;
    if (currentState is! UserMedicinesLoaded) return;

    final deletedIndex = _allMedicines.indexWhere((m) => m.id == localId);
    if (deletedIndex == -1) return;

    final deleted = _allMedicines[deletedIndex];

    final allCopy = List<MedicineModel>.from(_allMedicines)
      ..removeAt(deletedIndex);
    final filteredCopy = List<MedicineModel>.from(_filteredMedicines)
      ..removeWhere((m) => m.id == localId);

    _allMedicines = allCopy;
    _filteredMedicines = filteredCopy;
    emit(
      UserMedicinesLoaded(
        allMedicines: allCopy,
        filteredMedicines: filteredCopy,
        hasPendingSync: _hasPendingSync(allCopy),
        currentFilter: _currentFilter,
      ),
    );

    try {
      // Cancel native alarms before removing from the repository — best-effort.
      NotificationService.instance
          .cancelMedicineAlarms(localId, profileId: deleted.profileId)
          .ignore();
      await _repository.deleteMedicine(localId);
    } catch (e) {
      final allRevert = List<MedicineModel>.from(_allMedicines)
        ..insert(deletedIndex, deleted);
      final filteredRevert = List<MedicineModel>.from(_filteredMedicines)
        ..insert(deletedIndex, deleted);
      _allMedicines = allRevert;
      _filteredMedicines = filteredRevert;
      emit(
        UserMedicinesLoaded(
          allMedicines: allRevert,
          filteredMedicines: filteredRevert,
          hasPendingSync: _hasPendingSync(allRevert),
          currentFilter: _currentFilter,
        ),
      );
    }
  }

  Future<void> toggleMedicine(String localId) async {
    final currentState = state;
    if (currentState is! UserMedicinesLoaded) return;

    final index = _allMedicines.indexWhere((m) => m.id == localId);
    if (index == -1) return;

    final medicine = _allMedicines[index];
    final toggled = medicine.copyWith(
      isActive: !medicine.isActive,
      isPaused: false,
    );

    final allCopy = List<MedicineModel>.from(_allMedicines)..[index] = toggled;
    final filteredIndex = _filteredMedicines.indexWhere((m) => m.id == localId);
    if (filteredIndex != -1) {
      final filteredCopy = List<MedicineModel>.from(_filteredMedicines)
        ..[filteredIndex] = toggled;
      _filteredMedicines = filteredCopy;
    }
    _allMedicines = allCopy;
    emit(
      currentState.copyWith(
        allMedicines: allCopy,
        filteredMedicines: filteredIndex != -1
            ? _filteredMedicines
            : _filteredMedicines,
      ),
    );

    try {
      await _repository.toggleMedicineActive(localId);
      // Sync alarms with the new active state — best-effort.
      if (toggled.isActive) {
        NotificationService.instance.scheduleMedicineAlarms(toggled).ignore();
      } else {
        NotificationService.instance
            .cancelMedicineAlarms(localId, profileId: medicine.profileId)
            .ignore();
      }
    } catch (e) {
      final reverted = List<MedicineModel>.from(_allMedicines)
        ..[index] = medicine;
      _allMedicines = reverted;
      if (filteredIndex != -1) {
        final filteredRevert = List<MedicineModel>.from(_filteredMedicines)
          ..[filteredIndex] = medicine;
        _filteredMedicines = filteredRevert;
      }
      emit(
        currentState.copyWith(
          allMedicines: reverted,
          filteredMedicines: _filteredMedicines,
        ),
      );
    }
  }

  void filterByStatus(bool? isActive) {
    _currentFilter = isActive;
    _applyFilters();
  }

  void searchByName(String query) {
    _currentSearch = query.toLowerCase().trim();
    _applyFilters();
  }

  void _applyFilters() {
    var result = List<MedicineModel>.from(_allMedicines);

    if (_currentFilter != null) {
      result = result.where((m) => m.isActive == _currentFilter).toList();
    }

    if (_currentSearch.isNotEmpty) {
      result = result
          .where((m) => m.name.toLowerCase().contains(_currentSearch))
          .toList();
    }

    final hasPending = _hasPendingSync(_allMedicines);
    final currentState = state;
    if (currentState is UserMedicinesLoaded &&
        listEquals(currentState.allMedicines, _allMedicines) &&
        listEquals(currentState.filteredMedicines, result) &&
        currentState.hasPendingSync == hasPending &&
        currentState.currentFilter == _currentFilter) {
      return;
    }

    _filteredMedicines = result;
    emit(
      UserMedicinesLoaded(
        allMedicines: _allMedicines,
        filteredMedicines: _filteredMedicines,
        hasPendingSync: hasPending,
        currentFilter: _currentFilter,
      ),
    );
  }

  bool _hasPendingSync(List<MedicineModel> medicines) {
    return medicines.any((m) => m.syncStatus == SyncStatus.pending);
  }

  @override
  Future<void> close() async {
    await _medicinesSubscription?.cancel();
    return super.close();
  }
}
