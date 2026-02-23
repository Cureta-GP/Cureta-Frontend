import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/shared/widgets/date_selection_card.dart';
import 'package:flutter/material.dart';

class AgeStep extends StatefulWidget {
  const AgeStep({super.key});

  @override
  State<AgeStep> createState() => _AgeStepState();
}

class _AgeStepState extends State<AgeStep> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          DateSelectionCard(
            title: AppLocalizations.profilesAgeTitle,
            hintText: AppLocalizations.addRecordSelectDate,
            selectedDate: _selectedDate,
            onTap: () => _selectDate(context),
          ),
        ],
      ),
    );
  }
}
