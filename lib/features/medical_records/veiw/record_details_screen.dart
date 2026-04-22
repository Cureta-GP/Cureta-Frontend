import 'package:cureta/features/medical_records/data/models/medical_record_model.dart';
import 'package:cureta/features/medical_records/widgets/record_details_coordinator.dart';
import 'package:flutter/material.dart';

class RecordDetailsView extends StatelessWidget {
  const RecordDetailsView({
    super.key,
    this.record,
    required this.conditionName,
    required this.isOngoing,
    required this.diagnosedDate,
    required this.notes,
    this.onEdit,
    this.onDelete,
    this.onFileTap,
  });

  final MedicalRecordModel? record;
  final String conditionName;
  final bool isOngoing;
  final String diagnosedDate;
  final String notes;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<int>? onFileTap;

  @override
  Widget build(BuildContext context) {
    return RecordDetailsCoordinator(
      record: record,
      conditionName: conditionName,
      isOngoing: isOngoing,
      diagnosedDate: diagnosedDate,
      notes: notes,
      onEdit: onEdit,
      onDelete: onDelete,
      onFileTap: onFileTap,
    );
  }
}
