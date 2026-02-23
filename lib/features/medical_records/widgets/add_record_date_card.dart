import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/shared/widgets/date_selection_card.dart';
import 'package:flutter/material.dart';

class AddRecordDateCard extends StatelessWidget {
  const AddRecordDateCard({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  final DateTime? selectedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DateSelectionCard(
      title: AppLocalizations.addRecordFirstSymptomsQuestion,
      hintText: AppLocalizations.addRecordSelectDate,
      selectedDate: selectedDate,
      onTap: onTap,
    );
  }
}
