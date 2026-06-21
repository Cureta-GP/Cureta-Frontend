import 'package:equatable/equatable.dart';

abstract class QrGenerateTokenState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QrGenerateTokenInitial extends QrGenerateTokenState {}

class QrGenerateTokenLoading extends QrGenerateTokenState {}

class QrGenerateTokenSuccess extends QrGenerateTokenState {
  final String token;
  QrGenerateTokenSuccess(this.token);

  @override
  List<Object?> get props => [token];
}

class QrGenerateTokenError extends QrGenerateTokenState {
  final String message;
  QrGenerateTokenError(this.message);

  @override
  List<Object?> get props => [message];
}