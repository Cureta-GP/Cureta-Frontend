import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class BloodTypeStep extends StatefulWidget {
  const BloodTypeStep({super.key});

  @override
  State<BloodTypeStep> createState() => _BloodTypeStepState();
}

class _BloodTypeStepState extends State<BloodTypeStep> {
  String? _selectedBloodType;

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final radius = context.radius;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.md,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: spacing.md,
        crossAxisSpacing: spacing.md,
        childAspectRatio: 2.2,
      ),
      itemCount: _bloodTypes.length,
      itemBuilder: (context, index) {
        final bloodType = _bloodTypes[index];
        final isSelected = _selectedBloodType == bloodType;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedBloodType = bloodType;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : colors.background,
              borderRadius: BorderRadius.circular(radius.md),
              border: Border.all(
                color: isSelected
                    ? colors.primary
                    : colors.medicalRecordOptionBorder,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              bloodType,
              style: typography.medicalRecordChoice.copyWith(
                color: isSelected ? Colors.white : colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
