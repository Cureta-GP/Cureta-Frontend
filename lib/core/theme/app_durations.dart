import 'package:flutter/material.dart';

@immutable
class AppDurations extends ThemeExtension<AppDurations> {
  const AppDurations({
    required this.fast,
    required this.normal,
    required this.slow,
  });

  final Duration fast;
  final Duration normal;
  final Duration slow;

  static const standard = AppDurations(
    fast: Duration(milliseconds: 150),
    normal: Duration(milliseconds: 300),
    slow: Duration(milliseconds: 500),
  );

  @override
  AppDurations copyWith({Duration? fast, Duration? normal, Duration? slow}) {
    return AppDurations(
      fast: fast ?? this.fast,
      normal: normal ?? this.normal,
      slow: slow ?? this.slow,
    );
  }

  @override
  AppDurations lerp(ThemeExtension<AppDurations>? other, double t) {
    if (other is! AppDurations) return this;
    return AppDurations(
      fast: Duration(
        microseconds:
            (fast.inMicroseconds +
                    (other.fast.inMicroseconds - fast.inMicroseconds) * t)
                .round(),
      ),
      normal: Duration(
        microseconds:
            (normal.inMicroseconds +
                    (other.normal.inMicroseconds - normal.inMicroseconds) * t)
                .round(),
      ),
      slow: Duration(
        microseconds:
            (slow.inMicroseconds +
                    (other.slow.inMicroseconds - slow.inMicroseconds) * t)
                .round(),
      ),
    );
  }
}
