import 'package:equatable/equatable.dart';

abstract class QrCategoriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QrCategoriesInitial extends QrCategoriesState {}

class QrCategoriesLoading extends QrCategoriesState {}

class QrCategoriesLoaded extends QrCategoriesState {
  final List<String> categories;
  QrCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class QrCategoriesError extends QrCategoriesState {
  final String message;
  QrCategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}
