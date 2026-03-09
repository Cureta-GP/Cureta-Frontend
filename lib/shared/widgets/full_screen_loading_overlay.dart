import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class FullScreenLoadingOverlay extends StatelessWidget {
  const FullScreenLoadingOverlay({
    super.key,
    required this.lottiePath,
    required this.playOnceAndComplete,
    this.onComplete,
  });

  final String lottiePath;
  final bool playOnceAndComplete;
  final VoidCallback? onComplete;

  static OverlayEntry? _overlay;
  static void show(
    BuildContext context, {
    required String lottiePath,
    bool playOnceAndComplete = false,
    VoidCallback? onCompleted,
  }) {
    // 1. Remove the old overlay if it exists
    hide();

    // 2. Create a new completer
    final completer = Completer<void>();

    // 3. Create the new overlay entry explicitly
    _overlay = OverlayEntry(
      builder: (context) => _AnimatedOverlay(
        lottiePath: lottiePath,
        playOnceAndComplete: playOnceAndComplete,
        onComplete: () {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    // 4. Insert into the Overlay
    Overlay.of(context).insert(_overlay!);

    // 5. If playOnceAndComplete is true, wait for the Future then trigger callback
    if (playOnceAndComplete) {
      completer.future.then((_) async {
        // Add a slight delay to let the user see the final frame before it vanishes
        await Future.delayed(const Duration(milliseconds: 500));
        hide();
        onCompleted?.call();
      });
    }
  }

  /// Dismisses the currently showing overlay.
  static void hide() {
    if (_overlay != null) {
      _overlay!.remove();
      _overlay = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AnimatedOverlay(
      lottiePath: lottiePath,
      playOnceAndComplete: playOnceAndComplete,
      onComplete: onComplete,
    );
  }
}

class _AnimatedOverlay extends StatefulWidget {
  const _AnimatedOverlay({
    required this.lottiePath,
    required this.playOnceAndComplete,
    this.onComplete,
  });

  final String lottiePath;
  final bool playOnceAndComplete;
  final VoidCallback? onComplete;

  @override
  State<_AnimatedOverlay> createState() => _AnimatedOverlayState();
}

class _AnimatedOverlayState extends State<_AnimatedOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeIn;
  AnimationController? _lottieController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();

    if (widget.playOnceAndComplete) {
      _lottieController = AnimationController(vsync: this);
      _lottieController!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _lottieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: Material(
        color: Colors.transparent, // Completely transparent as requested
        child: Center(
          child: SizedBox(
            width: 400,
            height: 400,
            child: widget.playOnceAndComplete
                ? Lottie.asset(
                    widget.lottiePath,
                    controller: _lottieController,
                    onLoaded: (composition) {
                      _lottieController!.duration = composition.duration;
                      _lottieController!.forward(from: 0.0);
                    },
                    fit: BoxFit.contain,
                  )
                : Lottie.asset(widget.lottiePath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
