import 'package:cureta/features/qr/data/repo/qr_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cureta/features/qr/data/models/qr_share_token_request.dart';
import 'qr_generate_token_state.dart';

class QrGenerateTokenCubit extends Cubit<QrGenerateTokenState> {
  final QrRepository _repository;

  QrGenerateTokenCubit(this._repository) : super(QrGenerateTokenInitial());

  Future<void> generate(QrShareTokenRequest request) async {
    emit(QrGenerateTokenLoading());
    try {
      final shareUrl = await _repository.generateShareUrl(request);
      if (isClosed) return;
      emit(QrGenerateTokenSuccess(shareUrl));
    } catch (e) {
      if (isClosed) return;
      emit(QrGenerateTokenError(e.toString()));
    }
  }

  void reset() => emit(QrGenerateTokenInitial());
}
