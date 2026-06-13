import 'package:cureta/features/medical_records/veiw_model/record_details_state.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Lottie-based full-screen overlay shown during save/delete operations.
class RecordDetailsOverlay extends StatefulWidget {
  const RecordDetailsOverlay({super.key, required this.mode});

  final RecordBusyMode mode;

  @override
  State<RecordDetailsOverlay> createState() => _RecordDetailsOverlayState();
}

class _RecordDetailsOverlayState extends State<RecordDetailsOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;
  late Duration _fadeDuration;
  String? _activePath;

  @override
  void initState() {
    super.initState();
    _fadeDuration = const Duration(milliseconds: 150);
    _fade = AnimationController(vsync: this, duration: _fadeDuration);
    if (widget.mode.isActive) {
      _activePath = widget.mode.lottiePath;
      _fade.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextDuration = context.durations.fast;
    if (nextDuration != _fadeDuration) {
      _fadeDuration = nextDuration;
      _fade.duration = nextDuration;
      _fade.reverseDuration = nextDuration;
    }
  }

  @override
  void didUpdateWidget(RecordDetailsOverlay old) {
    super.didUpdateWidget(old);
    if (widget.mode.isActive && !old.mode.isActive) {
      _activePath = widget.mode.lottiePath;
      _fade.forward();
    } else if (!widget.mode.isActive && old.mode.isActive) {
      _fade.reverse();
    }
  }

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final path = widget.mode.isActive ? widget.mode.lottiePath : _activePath;
    if (path == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _fade,
      builder: (context, child) {
        final isVisible = widget.mode.isActive || !_fade.isDismissed;
        if (!isVisible) return const SizedBox.shrink();
        return IgnorePointer(
          ignoring: !widget.mode.isActive,
          child: FadeTransition(
            opacity: CurvedAnimation(parent: _fade, curve: Curves.easeInOut),
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: SizedBox(
                  width: context.spacing.xxl * 7,
                  height: context.spacing.xxl * 7,
                  child: Lottie.asset(path, fit: BoxFit.contain, repeat: false),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
