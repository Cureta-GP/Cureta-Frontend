import 'package:cureta/features/home/data/repo/schedule_repo.dart';
import 'package:cureta/features/home/view_model/home_schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScheduleCubit extends Cubit<HomeScheduleState> {
  HomeScheduleCubit(this._repository) : super(const HomeScheduleInitial());

  final ScheduleRepository _repository;

  Future<void> load(String profileId) async {
    emit(const HomeScheduleLoading());
    try {
      final entries = await _repository.getTodaySchedule(profileId);
      emit(HomeScheduleLoaded(entries));
    } catch (e) {
      emit(HomeScheduleError(e.toString()));
    }
  }

  /// Call after user marks a dose — just reload
  Future<void> refresh(String profileId) => load(profileId);
}
