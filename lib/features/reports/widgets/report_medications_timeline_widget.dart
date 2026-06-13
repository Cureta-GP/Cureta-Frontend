import 'package:flutter/material.dart';
import '../data/models/medication_timeline_model.dart';
import 'report_medication_bar_widget.dart';

class ReportMedicationsTimelineWidget extends StatelessWidget {
  const ReportMedicationsTimelineWidget({super.key, required this.medications});

  final List<MedicationTimelineModel> medications;

  @override
  Widget build(BuildContext context) {
    if (medications.isEmpty) return const SizedBox.shrink();
    return Column(
      children: medications
          .map((m) => ReportMedicationBarWidget(medication: m))
          .toList(),
    );
  }
}
