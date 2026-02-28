import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medical_records/widgets/add_record_date_card.dart';
import 'package:cureta/features/medical_records/widgets/add_record_ongoing_card.dart';
import 'package:cureta/shared/widgets/custom_screen_header.dart';
import 'package:cureta/shared/widgets/step_progress_indicator.dart';
import 'package:flutter/material.dart';

class AddRecordStepTwoBody extends StatelessWidget {
  const AddRecordStepTwoBody({
    super.key,
    this.onBack,
    required this.selectedDate,
    required this.isOngoing,
    required this.onPickDate,
    required this.onOngoingChanged,
  });

  final VoidCallback? onBack;
  final DateTime? selectedDate;
  final bool isOngoing;
  final VoidCallback onPickDate;
  final ValueChanged<bool> onOngoingChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      children: [
        CustomScreenHeader(
          title: AppLocalizations.addRecordBasicInfoTitle,
          onBack: onBack,
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: spacing.lg),
            children: [
              StepProgressIndicator(
                stepLabel: AppLocalizations.addRecordStep2Label,
                progressLabel: AppLocalizations.addRecordProgress40,
                progress: 0.4,
              ),
              SizedBox(height: spacing.xl),
              AddRecordDateCard(selectedDate: selectedDate, onTap: onPickDate),
              SizedBox(height: spacing.lg),
              AddRecordOngoingCard(
                isOngoing: isOngoing,
                onChanged: onOngoingChanged,
              ),
              SizedBox(height: spacing.xl),
            ],
          ),
        ),
      ],
    );
  }
}
