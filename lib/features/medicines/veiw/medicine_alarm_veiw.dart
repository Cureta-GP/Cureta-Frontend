import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/core/Services/notification_service.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/features/medicines/widgets/alarm_pulse_image_widget.dart';
import 'package:cureta/features/medicines/widgets/alarm_action_buttons_widget.dart';
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

class _MedicineAlarmVeiwState extends State<MedicineAlarmVeiw>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

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
    await NotificationService.instance.stopAlarm();
    await getIt<MedicineRepository>()
        .logMedicationAction(widget.localId, status);
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
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: spacing.xl,
            vertical: spacing.xl,
          ),
          child: Column(
            children: [
              const Spacer(),
              AlarmPulseImageWidget(
                animation: _animationController,
                scaleAnimation: _scaleAnimation,
                fadeAnimation: _fadeAnimation,
                imagePath: widget.imagePath,
              ),
              SizedBox(height: spacing.xl),
              Text(
                widget.name,
                style: typography.title.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.sm),
              Text(
                AppLocalizations.medicinesAlarmSubtitle,
                style: typography.body.copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.lg),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: spacing.xl,
                  vertical: spacing.sm,
                ),
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
              AlarmActionButtonsWidget(
                onTaken: () => _logAction('TAKEN'),
                onMissed: () => _logAction('MISSED'),
              ),
              SizedBox(height: spacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
