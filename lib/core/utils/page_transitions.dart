import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageTransitions {
  static const Duration _defaultDuration = Duration(milliseconds: 500);
  static const Curve _defaultCurve = Curves.easeInOut;

  /// No animation
  static CustomTransitionPage none({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, anim, secondaryAnim, child) => child,
    );
  }

  /// Fade transition
  static CustomTransitionPage fade({
    required Widget child,
    required GoRouterState state,
    Duration? duration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _defaultDuration,
      transitionsBuilder: (context, anim, secondaryAnim, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: _defaultCurve),
          child: child,
        );
      },
    );
  }

  /// Slide from right
  static CustomTransitionPage slideRight({
    required Widget child,
    required GoRouterState state,
    Duration? duration,
  }) {
    return _buildSlideTransition(
      child: child,
      state: state,
      offset: const Offset(1.0, 0.0),
      duration: duration,
    );
  }

  /// Slide from left
  static CustomTransitionPage slideLeft({
    required Widget child,
    required GoRouterState state,
    Duration? duration,
  }) {
    return _buildSlideTransition(
      child: child,
      state: state,
      offset: const Offset(-1.0, 0.0),
      duration: duration,
    );
  }

  /// Slide from bottom
  static CustomTransitionPage slideUp({
    required Widget child,
    required GoRouterState state,
    Duration? duration,
  }) {
    return _buildSlideTransition(
      child: child,
      state: state,
      offset: const Offset(0.0, 1.0),
      duration: duration,
    );
  }

  /// Slide from top
  static CustomTransitionPage slideDown({
    required Widget child,
    required GoRouterState state,
    Duration? duration,
  }) {
    return _buildSlideTransition(
      child: child,
      state: state,
      offset: const Offset(0.0, -1.0),
      duration: duration,
    );
  }

  /// Scale transition
  static CustomTransitionPage scale({
    required Widget child,
    required GoRouterState state,
    Duration? duration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _defaultDuration,
      transitionsBuilder: (context, anim, secondaryAnim, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: _defaultCurve),
          child: child,
        );
      },
    );
  }

  /// Helper method for slide transitions
  static CustomTransitionPage _buildSlideTransition({
    required Widget child,
    required GoRouterState state,
    required Offset offset,
    Duration? duration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _defaultDuration,
      transitionsBuilder: (context, anim, secondaryAnim, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: offset,
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: _defaultCurve)),
          child: child,
        );
      },
    );
  }
}