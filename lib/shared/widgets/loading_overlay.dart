import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A full-screen overlay that shows a **looping** Lottie loading animation.
///
/// Usage:
///   LoadingOverlay.show(context, lottiePath: '...');
///   LoadingOverlay.hide();
abstract class LoadingOverlay {
  static OverlayEntry? _overlay;

  /// Show a looping loading animation.
  static void show(BuildContext context, {required String lottiePath}) {
    hide();
    _overlay = OverlayEntry(
      builder: (_) => _LoadingContent(lottiePath: lottiePath),
    );
    Overlay.of(context).insert(_overlay!);
  }

  /// Dismiss the overlay.
  static void hide() {
    _overlay?.remove();
    _overlay = null;
  }
}

// ─────────────────────────────────────────────────────────────

class _LoadingContent extends StatefulWidget {
  const _LoadingContent({required this.lottiePath});
  final String lottiePath;

  @override
  State<_LoadingContent> createState() => _LoadingContentState();
}

class _LoadingContentState extends State<_LoadingContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
      child: Material(
        color: Colors.black26,
        child: Center(
          child: SizedBox(
            width: 280,
            height: 280,
            child: Lottie.asset(widget.lottiePath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
