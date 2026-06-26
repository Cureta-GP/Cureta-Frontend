import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import '../data/repo/report_repo.dart';
import 'report_setup_state.dart';

class ReportSetupCubit extends Cubit<ReportSetupState> {
  final ReportRepo _repo;
  final ProfileRepository _profileRepo;

  ReportSetupCubit(this._repo, this._profileRepo)
    : super(const ReportSetupInitial());

  // ── Initialisation ──────────────────────────────────────────────────────────

  Future<void> init() async {
    try {
      final profiles = await _profileRepo.getProfiles();
      final primary = profiles.isEmpty
          ? null
          : profiles.firstWhere(
              (p) => p.isPrimary,
              orElse: () => profiles.first,
            );
      if (isClosed) return;
      emit(
        ReportSetupUpdated(
          timePeriod: 'last_month',
          language: 'en',
          profiles: profiles,
          selectedProfile: primary,
        ),
      );
    } catch (_) {
      final d = _data();
      if (isClosed) return;
      emit(
        ReportSetupError(
          messageKey: 'reports.error_loading_profiles',
          timePeriod: d.period,
          language: d.lang,
          profiles: d.profiles,
          selectedProfile: d.profile,
        ),
      );
    }
  }

  // ── Field updates ────────────────────────────────────────────────────────────

  void selectProfile(ProfileModel profile) {
    final d = _data();
    emit(
      ReportSetupUpdated(
        timePeriod: d.period,
        language: d.lang,
        profiles: d.profiles,
        selectedProfile: profile,
      ),
    );
  }

  void selectTimePeriod(String period) {
    final d = _data();
    emit(
      ReportSetupUpdated(
        timePeriod: period,
        language: d.lang,
        profiles: d.profiles,
        selectedProfile: d.profile,
      ),
    );
  }

  void selectLanguage(String lang) {
    final d = _data();
    emit(
      ReportSetupUpdated(
        timePeriod: d.period,
        language: lang,
        profiles: d.profiles,
        selectedProfile: d.profile,
      ),
    );
  }

  // ── Generation ────────────────────────────────────────────────────────────────

  Future<void> generateReport() async {
    final d = _data();
    emit(
      ReportSetupGenerating(
        timePeriod: d.period,
        language: d.lang,
        profiles: d.profiles,
        selectedProfile: d.profile,
      ),
    );
    try {
      final profileId =
          d.profile?.id ??
          await _profileRepo.getResolvedSelectedProfileId() ??
          '';
      final report = await _repo.generateReport(
        profileId: profileId,
        timePeriod: d.period,
        language: d.lang,
      );
      if (isClosed) return;
      emit(ReportSetupSuccess(report: report));
    } catch (_) {
      if (isClosed) return;
      emit(
        ReportSetupError(
          messageKey: 'reports.error_generating',
          timePeriod: d.period,
          language: d.lang,
          profiles: d.profiles,
          selectedProfile: d.profile,
        ),
      );
    }
  }

  // ── Private ────────────────────────────────────────────────────────────────

  _D _data() => switch (state) {
    ReportSetupInitial s => _D(
      s.timePeriod,
      s.language,
      s.profiles,
      s.selectedProfile,
    ),
    ReportSetupUpdated s => _D(
      s.timePeriod,
      s.language,
      s.profiles,
      s.selectedProfile,
    ),
    ReportSetupGenerating s => _D(
      s.timePeriod,
      s.language,
      s.profiles,
      s.selectedProfile,
    ),
    ReportSetupError s => _D(
      s.timePeriod,
      s.language,
      s.profiles,
      s.selectedProfile,
    ),
    _ => _D('last_month', 'en', const [], null),
  };
}

/// Private data record used by [ReportSetupCubit] to read current form values.
class _D {
  final String period;
  final String lang;
  final List<ProfileModel> profiles;
  final ProfileModel? profile;
  const _D(this.period, this.lang, this.profiles, this.profile);
}
