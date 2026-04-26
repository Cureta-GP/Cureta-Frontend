import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class ScannedMedicinesScreen extends StatelessWidget {
  const ScannedMedicinesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.scannedMedicinesTitle),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(spacing.lg),
              children: [
                MedicineCard(
                  name: 'Amoxicillin 500mg',
                  confidence: 1.0,
                  isTablet: true,
                ),
                MedicineCard(
                  name: 'Ibuprofen 400mg',
                  confidence: 1.0,
                  isTablet: true,
                ),
                MedicineCard(
                  name: 'Parac?tamol',
                  confidence: 0.5,
                  isTablet: true,
                ),
                SizedBox(height: spacing.lg),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.scannedMedicinesAddAnother),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(AppLocalizations.scannedMedicinesConfirm),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.scannedMedicinesRescan),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String name;
  final double confidence;
  final bool isTablet;

  const MedicineCard({
    required this.name,
    required this.confidence,
    required this.isTablet,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final isLowConfidence = confidence < 0.7;
    return Card(
      margin: EdgeInsets.only(bottom: spacing.md),
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLowConfidence)
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 18),
                  SizedBox(width: spacing.xs),
                  Text(
                    AppLocalizations.scannedMedicinesLowConfidence,
                    style: typography.label.copyWith(color: Colors.orange),
                  ),
                ],
              ),
            Text(name, style: typography.title),
            if (isTablet)
              Row(
                children: [
                  Icon(Icons.medication, size: 18, color: colors.icon),
                  SizedBox(width: spacing.xs),
                  Text(
                    AppLocalizations.scannedMedicinesTablet,
                    style: typography.body,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
