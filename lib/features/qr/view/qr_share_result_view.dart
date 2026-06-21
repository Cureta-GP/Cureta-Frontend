import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrShareResultView extends StatelessWidget {
  final String shareUrl;

  const QrShareResultView({super.key, required this.shareUrl});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        title: const Text('Share via QR'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(spacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.divider),
                ),
                child: QrImageView(
                  data: shareUrl,
                  version: QrVersions.auto,
                  size: 240,
                ),
              ),
              SizedBox(height: spacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.copy, color: colors.primary),
                    tooltip: 'Copy link',
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: shareUrl));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link copied')),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Copy link',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: colors.textPrimary),
                  ),
                ],
              ),
              SizedBox(height: spacing.lg),
              Text(
                'Scan this code to view the shared records',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
              ),

              SizedBox(height: spacing.md),

              CustomButton(
                text: 'Done',
                onPressed: () {
                  if (context.mounted) {
                    context.goNamed(AppRoutes.mainNavigation);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
