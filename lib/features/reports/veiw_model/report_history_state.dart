import 'package:equatable/equatable.dart';
import '../data/models/health_report_model.dart';

sealed class ReportHistoryState extends Equatable {
  const ReportHistoryState();
}

final class ReportHistoryInitial extends ReportHistoryState {
  const ReportHistoryInitial();
  @override
  List<Object?> get props => [];
}

final class ReportHistoryLoading extends ReportHistoryState {
  const ReportHistoryLoading();
  @override
  List<Object?> get props => [];
}

final class ReportHistoryLoaded extends ReportHistoryState {
  final List<HealthReportModel> reports;
  const ReportHistoryLoaded({required this.reports});

  ReportHistoryLoaded copyWith({List<HealthReportModel>? reports}) =>
      ReportHistoryLoaded(reports: reports ?? this.reports);

  @override
  List<Object?> get props => [reports];
}

final class ReportHistoryEmpty extends ReportHistoryState {
  const ReportHistoryEmpty();
  @override
  List<Object?> get props => [];
}

final class ReportHistoryError extends ReportHistoryState {
  final String messageKey;
  const ReportHistoryError({required this.messageKey});
  @override
  List<Object?> get props => [messageKey];
}
