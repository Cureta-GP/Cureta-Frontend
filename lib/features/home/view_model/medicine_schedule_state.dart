import 'package:cureta/features/home/data/models/schedule_entry.dart';
import 'package:equatable/equatable.dart';

sealed class MedicineScheduleState extends Equatable {
  const MedicineScheduleState();

  @override
  List<Object?> get props => [];
}

class MedicineScheduleInitial extends MedicineScheduleState {
  const MedicineScheduleInitial();
}

class MedicineScheduleLoading extends MedicineScheduleState {
  const MedicineScheduleLoading();
}

class MedicineScheduleLoaded extends MedicineScheduleState {
  const MedicineScheduleLoaded({
    required this.selectedDate,
    required this.entries,
    this.updatingEntryKey,
  });

  final DateTime selectedDate;
  final List<ScheduleEntry> entries;
  final String? updatingEntryKey;

  @override
  List<Object?> get props => [selectedDate, entries, updatingEntryKey];
}

class MedicineScheduleError extends MedicineScheduleState {
  const MedicineScheduleError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
