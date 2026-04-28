import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/Services/notification_service.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import '../data/repo/medicine_repository.dart';

class MedicineAlarmVeiw extends StatefulWidget {
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

  @override
  State<MedicineAlarmVeiw> createState() => _MedicineAlarmVeiwState();
}

class _MedicineAlarmVeiwState extends State<MedicineAlarmVeiw> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _logAction(String status) async {
    // Stop the alarm sound FIRST
    await NotificationService.instance.stopAlarm();
    // Log the dose
    await getIt<MedicineRepository>().logMedicationAction(widget.localId, status);
    // Close the alarm full screen activity safely
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final radius = context.radius;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.xl, vertical: spacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Glowing Image
              SizedBox(
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    _buildImage(context),
                  ],
                ),
              ),
              SizedBox(height: spacing.xl),
              Text(
                widget.name,
                style: typography.title.copyWith(
                  color: colors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.sm),
              Text(
                AppLocalizations.medicinesAlarmSubtitle,
                style: typography.body.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.lg),
              Container(
                padding: EdgeInsets.symmetric(horizontal: spacing.xl, vertical: spacing.sm),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(radius.full),
                ),
                child: Text(
                  widget.doseAmount,
                  style: typography.body.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(flex: 2),
              
              // Taken Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _logAction('TAKEN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius.full),
                    ),
                    padding: EdgeInsets.symmetric(vertical: spacing.lg),
                    elevation: 4,
                  ),
                  child: Text(
                    AppLocalizations.medicinesAlarmTaken,
                    style: typography.button.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing.md),
              
              // Missed Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _logAction('MISSED'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.error,
                    side: BorderSide(color: colors.error, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius.full),
                    ),
                    padding: EdgeInsets.symmetric(vertical: spacing.lg),
                  ),
                  child: Text(
                    AppLocalizations.medicinesAlarmMissed,
                    style: typography.button.copyWith(
                      color: colors.error,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final colors = context.colors;
    
    if (widget.imagePath != null && widget.imagePath!.isNotEmpty) {
      final file = File(widget.imagePath!);
      if (file.existsSync()) {
        return Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.surface, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }
    
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: colors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: colors.primary, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Icon(
        Icons.medication,
        size: 80,
        color: colors.primary,
      ),
    );
  }
}
