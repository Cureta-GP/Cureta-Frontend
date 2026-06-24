import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/medicines/data/models/drug_interaction_model.dart';
import 'package:flutter/material.dart';

/// Shows a premium-styled drug interaction warning dialog.
///
/// Returns when the user dismisses the dialog.
Future<void> showDrugInteractionDialog(
  BuildContext context, {
  required DrugInteractionModel interactions,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: false,
    builder: (_) => _DrugInteractionDialog(interactions: interactions),
  );
}

class _DrugInteractionDialog extends StatelessWidget {
  const _DrugInteractionDialog({required this.interactions});

  final DrugInteractionModel interactions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: spacing.xl),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius.xl),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.75,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(radius.xl),
            border: Border.all(
              color: colors.accentOrange.withValues(alpha: 0.45),
              width: spacing.hairline,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.accentOrange.withValues(alpha: 0.18),
                blurRadius: spacing.xl,
                spreadRadius: spacing.xs,
                offset: Offset(0, spacing.sm),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DialogHeader(colors: colors, spacing: spacing),
              _DialogBody(
                interactions: interactions,
                colors: colors,
                spacing: spacing,
                radius: radius,
                typography: typography,
              ),
              _DialogFooter(
                colors: colors,
                spacing: spacing,
                radius: radius,
                typography: typography,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Amber/orange gradient header with warning icon.
class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.colors,
    required this.spacing,
  });

  final dynamic colors;
  final dynamic spacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: context.spacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.colors.accentOrange.withValues(alpha: 0.30),
            context.colors.accentOrange.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: context.spacing.xl +
              context.spacing.xxl +
              context.spacing.md,
          height: context.spacing.xl +
              context.spacing.xxl +
              context.spacing.md,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.accentOrange.withValues(alpha: 0.25),
            border: Border.all(
              color: context.colors.accentOrange.withValues(alpha: 0.45),
              width: context.spacing.hairline,
            ),
            boxShadow: [
              BoxShadow(
                color: context.colors.accentOrange.withValues(alpha: 0.25),
                blurRadius: context.spacing.lg,
                spreadRadius: context.spacing.xs,
              ),
            ],
          ),
          child: Icon(
            Icons.warning_amber_rounded,
            color: const Color(0xFFD97706),
            size: context.spacing.xxl,
          ),
        ),
      ),
    );
  }
}

/// Scrollable body: title, subtitle, and interaction cards.
class _DialogBody extends StatelessWidget {
  const _DialogBody({
    required this.interactions,
    required this.colors,
    required this.spacing,
    required this.radius,
    required this.typography,
  });

  final DrugInteractionModel interactions;
  final dynamic colors;
  final dynamic spacing;
  final dynamic radius;
  final dynamic typography;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;

    return Flexible(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          spacing.xl,
          spacing.md,
          spacing.xl,
          0,
        ),
        child: Column(
          children: [
            Text(
              AppLocalizations.drugInteractionTitle,
              textAlign: TextAlign.center,
              style: typography.medicalRecordScreenTitle.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: spacing.sm),
            Text(
              AppLocalizations.drugInteractionSubtitle,
              textAlign: TextAlign.center,
              style: typography.medicalRecordHelper.copyWith(
                color: colors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: spacing.lg),
            ...interactions.interactions.map(
              (detail) => _InteractionCard(
                detail: detail,
                colors: colors,
                spacing: spacing,
                radius: radius,
                typography: typography,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single interaction card with severity badge.
class _InteractionCard extends StatelessWidget {
  const _InteractionCard({
    required this.detail,
    required this.colors,
    required this.spacing,
    required this.radius,
    required this.typography,
  });

  final InteractionDetail detail;
  final dynamic colors;
  final dynamic spacing;
  final dynamic radius;
  final dynamic typography;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;
    final typography = context.typography;
    final severityColor = _severityColor(detail.severity);
    final severityLabel = _severityLabel(detail.severity);

    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(radius.lg),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.30),
          width: spacing.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.drugInteractionInteractsWith,
                      style: typography.label.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: spacing.xs / 2),
                    Text(
                      detail.medicine,
                      style: typography.body.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.xs / 2,
                ),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(radius.full),
                  border: Border.all(
                    color: severityColor.withValues(alpha: 0.35),
                    width: spacing.hairline,
                  ),
                ),
                child: Text(
                  severityLabel,
                  style: typography.label.copyWith(
                    color: severityColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (detail.description.isNotEmpty) ...[
            SizedBox(height: spacing.sm),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(spacing.md),
              decoration: BoxDecoration(
                color: severityColor.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(radius.md),
              ),
              child: Text(
                detail.description,
                style: typography.label.copyWith(
                  color: colors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _severityColor(String severity) {
    switch (severity.toUpperCase()) {
      case 'MAJOR':
        return const Color(0xFFDC2626);
      case 'MODERATE':
        return const Color(0xFFD97706);
      case 'MINOR':
        return const Color(0xFFCA8A04);
      default:
        return const Color(0xFFD97706);
    }
  }

  String _severityLabel(String severity) {
    switch (severity.toUpperCase()) {
      case 'MAJOR':
        return AppLocalizations.drugInteractionSeverityMajor;
      case 'MODERATE':
        return AppLocalizations.drugInteractionSeverityModerate;
      case 'MINOR':
        return AppLocalizations.drugInteractionSeverityMinor;
      default:
        return severity;
    }
  }
}

/// "I Understand" dismiss button.
class _DialogFooter extends StatelessWidget {
  const _DialogFooter({
    required this.colors,
    required this.spacing,
    required this.radius,
    required this.typography,
  });

  final dynamic colors;
  final dynamic spacing;
  final dynamic radius;
  final dynamic typography;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = context.radius;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.xl,
        spacing.md,
        spacing.xl,
        spacing.xl,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius.lg),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.30),
              blurRadius: spacing.lg,
              offset: Offset(0, spacing.xs),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.background,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: spacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.lg),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.drugInteractionDismiss,
            style: context.typography.button.copyWith(
              color: colors.background,
            ),
          ),
        ),
      ),
    );
  }
}
