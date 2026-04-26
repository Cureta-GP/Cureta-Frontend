import 'package:equatable/equatable.dart';
import '../data/models/medicine_model.dart';

sealed class UserMedicinesState extends Equatable {
  const UserMedicinesState();
}

final class UserMedicinesInitial extends UserMedicinesState {
  const UserMedicinesInitial();
  @override
  List<Object?> get props => [];
}

final class UserMedicinesLoading extends UserMedicinesState {
  final bool isRefresh;
  const UserMedicinesLoading({this.isRefresh = false});
  @override
  List<Object?> get props => [isRefresh];
}

final class UserMedicinesLoaded extends UserMedicinesState {
  final List<MedicineModel> allMedicines;
  final List<MedicineModel> filteredMedicines;
  final bool hasPendingSync;

  const UserMedicinesLoaded({
    required this.allMedicines,
    required this.filteredMedicines,
    required this.hasPendingSync,
  });

  UserMedicinesLoaded copyWith({
    List<MedicineModel>? allMedicines,
    List<MedicineModel>? filteredMedicines,
    bool? hasPendingSync,
  }) {
    return UserMedicinesLoaded(
      allMedicines: allMedicines ?? this.allMedicines,
      filteredMedicines: filteredMedicines ?? this.filteredMedicines,
      hasPendingSync: hasPendingSync ?? this.hasPendingSync,
    );
  }

  @override
  List<Object?> get props => [allMedicines, filteredMedicines, hasPendingSync];
}

final class UserMedicinesError extends UserMedicinesState {
  final String messageKey;
  const UserMedicinesError({required this.messageKey});
  @override
  List<Object?> get props => [messageKey];
}

final class UserMedicinesSyncBanner extends UserMedicinesState {
  final int failedCount;
  final UserMedicinesLoaded previousState;

  const UserMedicinesSyncBanner({
    required this.failedCount,
    required this.previousState,
  });

  @override
  List<Object?> get props => [failedCount, previousState];
}
