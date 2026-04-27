import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/Services/notification_service.dart';
import '../data/repo/medicine_repository.dart';

class MedicineAlarmVeiw extends StatelessWidget {
  final String localId;
  final String name;
  final String doseAmount;
  final String? imagePath;

  const MedicineAlarmVeiw({
    super.key,
    required this.localId,
    required this.name,
    required this.doseAmount,
    this.imagePath,
  });

  Future<void> _logAction(BuildContext context, String status) async {
    // Stop the alarm sound FIRST
    await NotificationService.instance.stopAlarm();
    // Log the dose
    await getIt<MedicineRepository>().logMedicationAction(localId, status);
    
    // Close the alarm full screen activity safely
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(child: _buildImage(context)),
              SizedBox(height: context.spacing.xxl),
              Text(
                name,
                style: context.typography.title.copyWith(
                  color: context.colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.spacing.md),
              Text(
                doseAmount,
                style: context.typography.body.copyWith(
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _logAction(context, 'TAKEN'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  padding: EdgeInsets.symmetric(vertical: context.spacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.radius.lg),
                  ),
                ),
                child: Text(
                  'Taken',
                  style: context.typography.button.copyWith(
                    color: context.colors.surface,
                  ),
                ),
              ),
              SizedBox(height: context.spacing.md),
              OutlinedButton(
                onPressed: () => _logAction(context, 'MISSED'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.colors.error, width: 2),
                  padding: EdgeInsets.symmetric(vertical: context.spacing.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.radius.lg),
                  ),
                ),
                child: Text(
                  'Missed',
                  style: context.typography.button.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ),
              SizedBox(height: context.spacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (imagePath != null && imagePath!.isNotEmpty) {
      final file = File(imagePath!);
      if (file.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(context.radius.xxl),
          child: Image.file(
            file,
            width: 500,
            height: 500,
            fit: BoxFit.cover,
          ),
        );
      }
    }
    
    return Container(
      width: 500,
      height: 500,
      decoration: BoxDecoration(
        color: context.colors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.primary, width: 6),
      ),
      child: Icon(
        Icons.medication,
        size: 140,
        color: context.colors.primary,
      ),
    );
  }
}
