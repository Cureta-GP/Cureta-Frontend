import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/record_details_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/record_details_state.dart';
import 'package:flutter/material.dart';

Future<void> runRecordSaveAction({
  required BuildContext context,
  required RecordDetailsCubit detailsCubit,
  required MedicalRecordsCubit? recordsCubit,
  required TextEditingController conditionController,
  required TextEditingController notesController,
  required VoidCallback syncControllers,
  required void Function(String) showMessage,
  required bool Function() isMounted,
}) async {
  final state = detailsCubit.state;
  if (state.record == null || recordsCubit == null) {
    showMessage(AppLocalizations.recordDetailsEditUnavailable);
    return;
  }

  final diseaseName = conditionController.text.trim();
  if (diseaseName.isEmpty) {
    showMessage(AppLocalizations.recordDetailsConditionRequired);
    return;
  }

  try {
    await detailsCubit.saveChanges(
      recordsCubit: recordsCubit,
      diseaseName: diseaseName,
      notes: notesController.text.trim(),
    );

    if (!isMounted()) return;
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!isMounted()) return;

    syncControllers();
    showMessage(AppLocalizations.recordDetailsUpdateSuccess);
  } on AppException catch (e) {
    if (!isMounted()) return;
    ErrorHandler.show(context, e);
  } on StateError {
    if (!isMounted()) return;
    showMessage(AppLocalizations.recordDetailsEditUnavailable);
  } catch (_) {
    if (!isMounted()) return;
    ErrorHandler.show(
      context,
      AppException.server(msg: AppLocalizations.recordDetailsUpdateFailed),
    );
  } finally {
    if (isMounted()) detailsCubit.setBusyMode(RecordBusyMode.none);
  }
}
