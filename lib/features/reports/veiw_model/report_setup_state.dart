import 'package:equatable/equatable.dart';
import 'package:cureta/features/profile/data/models/profile_model.dart';
import '../data/models/health_report_model.dart';

sealed class ReportSetupState extends Equatable {
  const ReportSetupState();
}

final class ReportSetupInitial extends ReportSetupState {
  final String timePeriod;
  final String language;
  final List<ProfileModel> profiles;
  final ProfileModel? selectedProfile;

  const ReportSetupInitial({
    this.timePeriod = 'last_month',
    this.language = 'en',
    this.profiles = const [],
    this.selectedProfile,
  });

  @override
  List<Object?> get props => [timePeriod, language, profiles, selectedProfile];
}

final class ReportSetupUpdated extends ReportSetupState {
  final String timePeriod;
  final String language;
  final List<ProfileModel> profiles;
  final ProfileModel? selectedProfile;

  const ReportSetupUpdated({
    required this.timePeriod,
    required this.language,
    required this.profiles,
    this.selectedProfile,
  });

  ReportSetupUpdated copyWith({
    String? timePeriod,
    String? language,
    List<ProfileModel>? profiles,
    ProfileModel? selectedProfile,
    bool clearSelectedProfile = false,
  }) {
    return ReportSetupUpdated(
      timePeriod: timePeriod ?? this.timePeriod,
      language: language ?? this.language,
      profiles: profiles ?? this.profiles,
      selectedProfile: clearSelectedProfile
          ? null
          : selectedProfile ?? this.selectedProfile,
    );
  }

  @override
  List<Object?> get props => [timePeriod, language, profiles, selectedProfile];
}

final class ReportSetupGenerating extends ReportSetupState {
  final String timePeriod;
  final String language;
  final List<ProfileModel> profiles;
  final ProfileModel? selectedProfile;

  const ReportSetupGenerating({
    required this.timePeriod,
    required this.language,
    required this.profiles,
    this.selectedProfile,
  });

  @override
  List<Object?> get props => [timePeriod, language, profiles, selectedProfile];
}

final class ReportSetupSuccess extends ReportSetupState {
  final HealthReportModel report;
  const ReportSetupSuccess({required this.report});
  @override
  List<Object?> get props => [report];
}

final class ReportSetupError extends ReportSetupState {
  final String messageKey;
  final String timePeriod;
  final String language;
  final List<ProfileModel> profiles;
  final ProfileModel? selectedProfile;

  const ReportSetupError({
    required this.messageKey,
    required this.timePeriod,
    required this.language,
    required this.profiles,
    this.selectedProfile,
  });

  @override
  List<Object?> get props => [
    messageKey,
    timePeriod,
    language,
    profiles,
    selectedProfile,
  ];
}
