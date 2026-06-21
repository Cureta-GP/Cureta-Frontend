import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/Services/notification_service.dart';
import '../data/models/medicine_enums.dart';
import '../data/repo/medicine_repository.dart';
import 'medicine_details_state.dart';

class MedicineDetailsCubit extends Cubit<MedicineDetailsState> {
  final MedicineRepository _repository;
  final String medicineId;

  MedicineDetailsCubit(
    this._repository, {
    required this.medicineId,
  }) : super(const MedicineDetailsInitial());

  Future<void> loadDetails() async {
    emit(const MedicineDetailsLoading());
    try {
      await NotificationService.instance.syncPendingAlarmActions();
      final medicine = await _repository.getMedicineById(medicineId);
      if (medicine != null) {
        final logs = await _repository.getMedicineLogs(medicineId);
        emit(MedicineDetailsLoaded(medicine: medicine, logs: logs));
      } else {
        emit(const MedicineDetailsError('medicines.error_medicine_not_found'));
      }
    } catch (e) {
      emit(const MedicineDetailsError('medicines.error_loading_details'));
    }
  }

  Future<void> toggleActive(bool value) async {
    if (state is MedicineDetailsLoaded) {
      final currentState = state as MedicineDetailsLoaded;
      try {
        await _repository.toggleMedicineActive(medicineId);
        // Reload details after toggling to get updated status
        await loadDetails();
      } catch (e) {
        emit(const MedicineDetailsError('medicines.error_toggling_status'));
        // Re-emit previous loaded state to recover UI
        emit(currentState);
      }
    }
  }

  void startEdit() {
    if (state is MedicineDetailsLoaded) {
      emit((state as MedicineDetailsLoaded).copyWith(isEditing: true));
    }
  }

  void cancelEdit() {
    if (state is MedicineDetailsLoaded) {
      emit((state as MedicineDetailsLoaded).copyWith(isEditing: false));
    }
  }

  void setBusyMode(MedicineBusyMode mode) {
    if (state is MedicineDetailsLoaded) {
      emit((state as MedicineDetailsLoaded).copyWith(busyMode: mode));
    }
  }

  Future<void> saveChanges({
    required String name,
    required String doseAmount,
    required String doseUnit,
    required String notes,
    required List<String> alarmTimes,
    required Frequency frequency,
    String? imagePath,
  }) async {
    if (state is! MedicineDetailsLoaded) return;
    final currentState = state as MedicineDetailsLoaded;
    setBusyMode(MedicineBusyMode.saving);
    try {
      final updatedMedicine = currentState.medicine.copyWith(
        name: name,
        doseAmount: doseAmount,
        doseUnit: doseUnit,
        notes: notes,
        alarmTimes: alarmTimes,
        frequency: frequency,
        imagePath: imagePath,
        updatedAt: DateTime.now(),
      );
      final savedMedicine = await _repository.updateMedicine(updatedMedicine);
      await NotificationService.instance.cancelMedicineAlarms(
        currentState.medicine.id,
        profileId: currentState.medicine.profileId,
      );
      if (savedMedicine.alarmTimes.isNotEmpty) {
        await NotificationService.instance.scheduleMedicineAlarms(savedMedicine);
      }
      // Let animation play
      await Future.delayed(const Duration(milliseconds: 1200));
      emit(currentState.copyWith(
        medicine: savedMedicine,
        isEditing: false,
        busyMode: MedicineBusyMode.none,
      ));
    } catch (e) {
      setBusyMode(MedicineBusyMode.none);
      rethrow;
    }
  }

  Future<void> deleteMedicine() async {
    if (state is! MedicineDetailsLoaded) return;
    setBusyMode(MedicineBusyMode.deleting);
    try {
      await _repository.deleteMedicine(medicineId);
      // Let animation play
      await Future.delayed(const Duration(milliseconds: 1200));
    } catch (e) {
      setBusyMode(MedicineBusyMode.none);
      rethrow;
    }
  }
}
