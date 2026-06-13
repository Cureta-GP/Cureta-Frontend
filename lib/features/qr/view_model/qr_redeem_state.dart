import 'package:equatable/equatable.dart';

abstract class QrRedeemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QrRedeemInitial extends QrRedeemState {}

class QrRedeemLoading extends QrRedeemState {}

class QrRedeemSuccess extends QrRedeemState {
  final String html;
  QrRedeemSuccess(this.html);

  @override
  List<Object?> get props => [html];
}

class QrRedeemError extends QrRedeemState {
  final String message;
  QrRedeemError(this.message);

  @override
  List<Object?> get props => [message];
}