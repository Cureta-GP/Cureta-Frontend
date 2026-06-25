import 'package:cureta/features/qr/data/repo/qr_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'qr_redeem_state.dart';

class QrRedeemCubit extends Cubit<QrRedeemState> {
  final QrRepository _repository;

  QrRedeemCubit(this._repository) : super(QrRedeemInitial());

  Future<void> redeem(String token) async {
    emit(QrRedeemLoading());
    try {
      final html = await _repository.redeemToken(token);
      if (isClosed) return;
      emit(QrRedeemSuccess(html));
    } catch (e) {
      if (isClosed) return;
      emit(QrRedeemError(e.toString()));
    }
  }
}
