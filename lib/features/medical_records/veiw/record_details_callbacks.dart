import 'package:cureta/features/medical_records/veiw/record_details_utils.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/record_details_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/record_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showRecordDetailsMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

MedicalRecordsCubit? readRecordListCubit(BuildContext context) {
  try {
    return context.read<MedicalRecordsCubit>();
  } catch (_) {
    return null;
  }
}

void syncRecordControllers({
  required RecordDetailsState state,
  required String fallbackCondition,
  required String fallbackNotes,
  required TextEditingController conditionController,
  required TextEditingController notesController,
}) {
  final condition = state.record?.diseaseName ?? fallbackCondition;
  final notes = state.record?.notes ?? fallbackNotes;

  if (conditionController.text != condition) {
    conditionController.text = condition;
  }
  if (notesController.text != notes) {
    notesController.text = notes;
  }
}

Future<void> pickRecordDate({
  required BuildContext context,
  required RecordDetailsCubit detailsCubit,
}) async {
  final state = detailsCubit.state;
  final picked = await showDatePicker(
    context: context,
    initialDate: state.editedDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );
  if (picked == null || !context.mounted) return;
  detailsCubit.setDate(picked);
}

void handleRecordFileTap({
  required BuildContext context,
  required RecordDetailsCubit detailsCubit,
  required int index,
  required void Function(String) onError,
  required ValueChanged<int>? externalFileTap,
}) {
  if (externalFileTap != null) {
    externalFileTap(index);
    return;
  }

  final files = buildRecordFilesFromAttachments(
    context,
    detailsCubit.state.record?.attachments ?? const [],
  );
  if (index >= files.length) return;
  openRecordFile(context, files[index], onError: onError);
}
