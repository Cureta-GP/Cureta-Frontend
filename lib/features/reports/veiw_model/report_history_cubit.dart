import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import '../data/repo/report_repo.dart';
import 'report_history_state.dart';

class ReportHistoryCubit extends Cubit<ReportHistoryState> {
  final ReportRepo _repo;

  ReportHistoryCubit(this._repo) : super(const ReportHistoryInitial());

  Future<void> loadHistory() async {
    emit(const ReportHistoryLoading());
    try {
      final profileId = await _getProfileId();
      final reports = await _repo.getReportsHistory(profileId: profileId);
      if (reports.isEmpty) {
        emit(const ReportHistoryEmpty());
      } else {
        emit(ReportHistoryLoaded(reports: reports));
      }
    } catch (_) {
      emit(
        const ReportHistoryError(messageKey: 'reports.error_loading_history'),
      );
    }
  }

  Future<void> refresh() => loadHistory();

  Future<String> _getProfileId() async {
    return await getIt<ProfileRepository>().getResolvedSelectedProfileId() ??
        '';
  }
}
