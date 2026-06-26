import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cureta/features/ocr/data/repo/ocr_repository.dart';
import '../data/models/ocr_medicine_match.dart';
import '../data/models/ocr_scan_response.dart';
import '../data/models/ocr_confirm_response.dart';
import 'ocr_state.dart';

class OcrCubit extends Cubit<OcrState> {
  final OcrRepository repository;

  List<OcrMedicineMatch> currentMedicines = [];

  OcrCubit({required this.repository}) : super(OcrInitial());

  void initializeMedicines(List<OcrMedicineMatch> medicines) {
    currentMedicines = List.from(medicines);
    emit(OcrMedicinesUpdated(medicines: List.from(currentMedicines)));
  }

  void deleteMedicine(int index) {
    currentMedicines.removeAt(index);
    emit(OcrMedicinesUpdated(medicines: List.from(currentMedicines)));
  }

  Future<void> scanPrescription(File imageFile) async {
    emit(OcrLoading());
    try {
      final resp = await repository.scan(imageFile.path);
      if (isClosed) return;
      emit(OcrScanSuccess(response: resp));
    } catch (e) {
      if (isClosed) return;
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
      if (isClosed) return;
      emit(OcrConfirmSuccess(response: resp));
    } catch (e) {
      if (isClosed) return;
      emit(OcrFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  void reset() {
    currentMedicines.clear();
    emit(OcrInitial());
  }
}
