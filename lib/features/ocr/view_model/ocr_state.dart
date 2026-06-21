import 'package:equatable/equatable.dart';
import '../data/models/ocr_medicine_match.dart'; // استيراد الموديل هنا أيضاً
import '../data/models/ocr_scan_response.dart';
import '../data/models/ocr_confirm_response.dart';

/// States for the OCR Cubit
abstract class OcrState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OcrInitial extends OcrState {}

class OcrLoading extends OcrState {}

// 3. الحالة الجديدة التي تطلق عند تحديث أو حذف الأدوية
class OcrMedicinesUpdated extends OcrState {
  final List<OcrMedicineMatch> medicines;

  OcrMedicinesUpdated({required this.medicines});

  @override
  List<Object?> get props => [medicines];
}

class OcrScanSuccess extends OcrState {
  final OcrScanResponse response;
  OcrScanSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class OcrConfirmSuccess extends OcrState {
  final OcrConfirmResponse response;
  OcrConfirmSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class OcrFailure extends OcrState {
  final String message;
  OcrFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
