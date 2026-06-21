import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/Services/notification_service.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import '../data/models/medicine_payload.dart';
import '../data/models/medicine_enums.dart';
import '../data/repo/medicine_repository.dart';
import 'add_medicine_state.dart';

class AddMedicineCubit extends Cubit<AddMedicineState> {
  final MedicineRepository _repository;

  AddMedicineCubit(this._repository) : super(const AddMedicineInitial());

  Future<String> _getProfileId() async {
    final profileRepo = getIt<ProfileRepository>();
    return await profileRepo.getResolvedSelectedProfileId() ?? '';
  }

  AddMedicineStepUpdated _currentData() {
    return switch (state) {
      AddMedicineInitial() => AddMedicineStepUpdated(startDate: DateTime.now()),
      AddMedicineStepUpdated data => data,
      AddMedicineValidated data => data.data,
      AddMedicineScanRequested data => data.data,
      AddMedicineLoading data => data.data,
      AddMedicineFailure data => data.data,
      AddMedicineSuccess() => AddMedicineStepUpdated(startDate: DateTime.now()),
    };
  }

  void updateMedicineName(String value) {
    final current = _currentData();
    final errors = Map<String, String>.from(current.validationErrors);
    errors.remove('medicineName');
    emit(current.copyWith(medicineName: value, validationErrors: errors));
  }

  void updateDoseForm(DoseForm form) {
    final current = _currentData();
    final errors = Map<String, String>.from(current.validationErrors);
    errors.remove('doseForm');
    emit(current.copyWith(doseForm: form, validationErrors: errors));
  }

  void updateDoseAmount(String amount) {
    final current = _currentData();
    emit(current.copyWith(doseAmount: amount));
  }

  void updateDoseUnit(String unit) {
    final current = _currentData();
    emit(current.copyWith(doseUnit: unit));
  }

  void updateFrequency(Frequency frequency) {
    final current = _currentData();
    final errors = Map<String, String>.from(current.validationErrors);
    errors.remove('frequency');
    emit(current.copyWith(frequency: frequency, validationErrors: errors));
  }

  void addAlarmTime(TimeOfDay time) {
    final current = _currentData();
    final times = List<TimeOfDay>.from(current.alarmTimes)..add(time);
    times.sort((a, b) {
      final aMinutes = a.hour * 60 + a.minute;
      final bMinutes = b.hour * 60 + b.minute;
      return aMinutes.compareTo(bMinutes);
    });
    emit(current.copyWith(alarmTimes: times));
  }

  void removeAlarmTime(int index) {
    final current = _currentData();
    if (index < 0 || index >= current.alarmTimes.length) return;
    final times = List<TimeOfDay>.from(current.alarmTimes)..removeAt(index);
    emit(current.copyWith(alarmTimes: times));
  }

  void updateStartDate(DateTime date) {
    final current = _currentData();
    emit(current.copyWith(startDate: date));
  }

  void updateNotes(String notes) {
    final current = _currentData();
    emit(current.copyWith(notes: notes));
  }

  void updateImagePath(String path) {
    final current = _currentData();
    emit(current.copyWith(imagePath: path));
  }

  void validateStep1() {
    final current = _currentData();
    if (current.medicineName.trim().isEmpty) {
      final errors = Map<String, String>.from(current.validationErrors);
      errors['medicineName'] = 'medicines.error_medicine_name_required';
      emit(current.copyWith(validationErrors: errors));
      return;
    }
    emit(AddMedicineValidated(stepNumber: 1, data: current));
  }

  void validateStep2() {
    final current = _currentData();
    final errors = <String, String>{};
    if (current.doseForm == null) {
      errors['doseForm'] = 'medicines.this_field_is_required';
    }
    if (current.frequency == null) {
      errors['frequency'] = 'medicines.this_field_is_required';
    }
    if (current.doseAmount.trim().isEmpty) {
      errors['doseAmount'] = 'medicines.this_field_is_required';
    }
    if (errors.isNotEmpty) {
      emit(current.copyWith(validationErrors: errors));
      return;
    }
    emit(AddMedicineValidated(stepNumber: 2, data: current));
  }

  void validateStep3() {
    final current = _currentData();
    emit(AddMedicineValidated(stepNumber: 3, data: current));
  }

  void requestScan() {
    final current = _currentData();
    emit(AddMedicineScanRequested(data: current));
  }

  Future<void> submitMedicine() async {
    final current = _currentData();
    emit(AddMedicineLoading(data: current));

    try {
      final payload = await _buildPayload(current);
      final medicine = await _repository.addMedicine(payload);

      // Schedule a native alarm for every reminder time — best-effort,
      // a failure here must never block the save flow.
      if (medicine.alarmTimes.isNotEmpty) {
        NotificationService.instance
            .scheduleMedicineAlarms(medicine)
            .ignore();
      }

      emit(AddMedicineSuccess(medicine: medicine));
    } catch (e) {
      emit(
        AddMedicineFailure(
          errorMessage: 'medicines.error_medicine_submit_failed',
          data: current,
        ),
      );
    }
  }

  Future<MedicinePayload> _buildPayload(AddMedicineStepUpdated data) async {
    final times = data.alarmTimes.map((t) {
      final hour = t.hour.toString().padLeft(2, '0');
      final minute = t.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }).toList();

    return MedicinePayload(
      profileId: await _getProfileId(),
      name: data.medicineName,
      dose: data.dose,
      frequency: data.frequency ?? Frequency.daily,
      reminders: times,
      startDate: data.startDate.toIso8601String(),
      notes: data.notes.isEmpty ? null : data.notes,
      doseForm: data.doseForm,
      imagePath: data.imagePath,
    );
  }

  void resetForm() {
    emit(const AddMedicineInitial());
  }
}
