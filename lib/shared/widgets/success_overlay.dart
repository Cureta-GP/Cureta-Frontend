import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A full-screen overlay that plays a Lottie animation **once**,
/// slides up from the bottom, and optionally shows a success [message].
///
/// Usage:
///   SuccessOverlay.show(context, lottiePath: '...', message: '...', onFinished: () {});
abstract class SuccessOverlay {
  static OverlayEntry? _overlay;

  /// Show a play-once success animation with slide-up entrance.
  static void show(
    BuildContext context, {
    required String lottiePath,
    String? message,
    VoidCallback? onFinished,
  }) {
    hide();
    final completer = Completer<void>();

    _overlay = OverlayEntry(
      builder: (_) => _SuccessContent(
        lottiePath: lottiePath,
        message: message,
        onAnimationComplete: () {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    Overlay.of(context).insert(_overlay!);

    completer.future.then((_) async {
      await Future.delayed(const Duration(milliseconds: 800));
      hide();
      onFinished?.call();
    });
  }

  /// Dismiss the overlay.
  static void hide() {
    _overlay?.remove();
    _overlay = null;
  }
}

// ─────────────────────────────────────────────────────────────

class _SuccessContent extends StatefulWidget {
  const _SuccessContent({
    required this.lottiePath,
    this.message,
    this.onAnimationComplete,
  });

  final String lottiePath;
  final String? message;
  final VoidCallback? onAnimationComplete;

  @override
  State<_SuccessContent> createState() => _SuccessContentState();
}

class _SuccessContentState extends State<_SuccessContent>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _slide = Tween(begin: const Offset(0, 0.35), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );
    _fade = CurvedAnimation(parent: _entranceController, curve: Curves.easeOut);
    _entranceController.forward();

    _lottieController = AnimationController(vsync: this)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) widget.onAnimationComplete?.call();
      });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.black26,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Lottie.asset(
                    widget.lottiePath,
                    controller: _lottieController,
                    onLoaded: (c) {
                      _lottieController.duration = c.duration;
                      _lottieController.forward(from: 0.0);
                    },
                    fit: BoxFit.contain,
                  ),
                ),
                if (widget.message != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.message!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
