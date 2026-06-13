import 'package:cureta/features/qr/data/repo/qr_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'qr_categories_state.dart';

class QrCategoriesCubit extends Cubit<QrCategoriesState> {
  final QrRepository _repository;

  QrCategoriesCubit(this._repository) : super(QrCategoriesInitial());

  Future<void> fetchCategories({String? profileId}) async {
    emit(QrCategoriesLoading());
    try {
      final categories = await _repository.getRecordsCategories(
        profileId: profileId,
      );
      emit(QrCategoriesLoaded(categories));
    } catch (e) {
      emit(QrCategoriesError(e.toString()));
    }
  }
}
