import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cureta/features/ocr/data/repo/ocr_repository.dart';
import '../data/models/ocr_scan_response.dart';
import '../data/models/ocr_confirm_response.dart';
import 'ocr_state.dart';

class OcrCubit extends Cubit<OcrState> {
  final OcrRepository repository;

  OcrCubit({required this.repository}) : super(OcrInitial());

  Future<void> scanPrescription(File imageFile) async {
    emit(OcrLoading());
    try {
      final resp = await repository.scan(imageFile.path);
      emit(OcrScanSuccess(response: resp));
    } catch (e) {
      emit(OcrFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> confirmMedicines({
    required List<String> medicines,
    required String profileId,
  }) async {
    emit(OcrLoading());
    try {
      final resp = await repository.confirm(
        medicines: medicines,
        profileId: profileId,
      );
      emit(OcrConfirmSuccess(response: resp));
    } catch (e) {
      emit(OcrFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  void reset() => emit(OcrInitial());
}
