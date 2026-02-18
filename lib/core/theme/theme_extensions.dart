import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_durations.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

extension ThemeContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  AppTypography get typography {
    return Theme.of(this).extension<AppTypography>() ?? AppTypography.mobile;
  }

  AppSpacing get spacing {
    return Theme.of(this).extension<AppSpacing>() ?? AppSpacing.mobile;
  }

  AppColors get colors {
    return Theme.of(this).extension<AppColors>() ?? AppColors.light;
  }

  AppDurations get durations {
    return Theme.of(this).extension<AppDurations>() ?? AppDurations.standard;
  }

  AppRadius get radius {
    return Theme.of(this).extension<AppRadius>() ?? AppRadius.mobile;
  }
}
