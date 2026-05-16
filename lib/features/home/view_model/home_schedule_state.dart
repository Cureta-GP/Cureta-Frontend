import 'package:equatable/equatable.dart';
import 'package:cureta/features/home/data/models/schedule_entry.dart';

sealed class HomeScheduleState extends Equatable {
  const HomeScheduleState();
  @override
  List<Object?> get props => [];
}

class HomeScheduleInitial extends HomeScheduleState {
  const HomeScheduleInitial();
}

class HomeScheduleLoading extends HomeScheduleState {
  const HomeScheduleLoading();
}

class HomeScheduleLoaded extends HomeScheduleState {
  const HomeScheduleLoaded(this.entries);
  final List<ScheduleEntry> entries;

  List<ScheduleEntry> get pending =>
      entries.where((e) => e.status == DoseStatus.pending).toList();

  List<ScheduleEntry> get taken =>
      entries.where((e) => e.status == DoseStatus.taken).toList();

  List<ScheduleEntry> get missed =>
      entries.where((e) => e.status == DoseStatus.missed).toList();

  /// Next upcoming dose (earliest pending)
  ScheduleEntry? get nextDose => pending.isEmpty ? null : pending.first;

  @override
  List<Object?> get props => [entries];
}

class HomeScheduleError extends HomeScheduleState {
  const HomeScheduleError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
