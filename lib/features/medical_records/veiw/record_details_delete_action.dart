import 'package:cureta/core/error_handling/app_exceptions.dart';
import 'package:cureta/core/error_handling/error_handler.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medical_records/veiw_model/medical_records_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/record_details_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/record_details_state.dart';
import 'package:cureta/features/medical_records/widgets/record_details_delete_dialog.dart';
import 'package:flutter/material.dart';

Future<void> runRecordDeleteAction({
  required BuildContext context,
  required RecordDetailsCubit detailsCubit,
  required MedicalRecordsCubit? recordsCubit,
  required void Function(String) showMessage,
  required bool Function() isMounted,
  required VoidCallback onDeleted,
}) async {
  final state = detailsCubit.state;
  if (state.record == null || recordsCubit == null) {
    showMessage(AppLocalizations.recordDetailsDeleteUnavailable);
    return;
  }

  final confirmed = await showRecordDeleteConfirmationDialog(
    context,
    conditionName: state.record!.diseaseName,
  );
  if (confirmed != true || !isMounted()) return;

  try {
    await detailsCubit.deleteCurrent(recordsCubit: recordsCubit);
    if (!isMounted()) return;
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!isMounted()) return;

    showMessage(AppLocalizations.recordDetailsDeleteSuccess);
    onDeleted();
  } on AppException catch (e) {
    if (!isMounted()) return;
    ErrorHandler.show(context, e);
  } on StateError {
    if (!isMounted()) return;
    showMessage(AppLocalizations.recordDetailsDeleteUnavailable);
  } catch (_) {
    if (!isMounted()) return;
    ErrorHandler.show(
      context,
      AppException.server(msg: AppLocalizations.recordDetailsDeleteFailed),
    );
  } finally {
    if (isMounted()) detailsCubit.setBusyMode(RecordBusyMode.none);
  }
}
