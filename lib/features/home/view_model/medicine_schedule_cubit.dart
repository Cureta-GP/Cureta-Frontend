import 'package:cureta/features/home/data/models/schedule_entry.dart';
import 'package:cureta/features/home/data/schedule_builder.dart';
import 'package:cureta/features/home/view_model/medicine_schedule_state.dart';
import 'package:cureta/features/medicines/data/repo/medicine_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicineScheduleCubit extends Cubit<MedicineScheduleState> {
  MedicineScheduleCubit(this._medicineRepository)
    : super(const MedicineScheduleInitial());

  final MedicineRepository _medicineRepository;
  String? _profileId;
  bool _isLoading = false;

  static String entryKey(ScheduleEntry entry) =>
      '${entry.medicineId}_${entry.scheduledAt.millisecondsSinceEpoch}';

  Future<void> load(String profileId, {DateTime? date}) async {
    if (_isLoading) return;
    _profileId = profileId;
    _isLoading = true;

    final selectedDate = _normalizeDate(date ?? _selectedDateOrToday());
    emit(const MedicineScheduleLoading());

    try {
      await _medicineRepository.refreshMedicines();
      final medicines = await _medicineRepository.getUserMedicines();
      final entries = await ScheduleBuilder.buildForDate(
        repository: _medicineRepository,
        medicines: medicines,
        date: selectedDate,
      );
      emit(MedicineScheduleLoaded(selectedDate: selectedDate, entries: entries));
    } catch (e) {
      emit(MedicineScheduleError(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  Future<void> selectDate(DateTime date) async {
    final profileId = _profileId;
    if (profileId == null) return;
    await load(profileId, date: date);
  }

  Future<void> updateStatus(ScheduleEntry entry, DoseStatus status) async {
    final current = state;
    if (current is! MedicineScheduleLoaded) return;

    final key = entryKey(entry);
    emit(
      MedicineScheduleLoaded(
        selectedDate: current.selectedDate,
        entries: current.entries,
        updatingEntryKey: key,
      ),
    );

    try {
      await _medicineRepository.logMedicationAction(
        entry.medicineId,
        status.raw,
        scheduledAt: entry.scheduledAt,
      );

      final profileId = _profileId;
      if (profileId != null) {
        await load(profileId, date: current.selectedDate);
      }
    } catch (e) {
      emit(MedicineScheduleError(e.toString()));
    }
  }

  DateTime _selectedDateOrToday() {
    final current = state;
    if (current is MedicineScheduleLoaded) return current.selectedDate;
    return _normalizeDate(DateTime.now());
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
