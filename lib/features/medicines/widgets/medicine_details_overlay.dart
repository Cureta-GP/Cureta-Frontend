import 'package:cureta/features/medicines/veiw_model/medicine_details_state.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MedicineDetailsOverlay extends StatefulWidget {
  const MedicineDetailsOverlay({super.key, required this.mode});

  final MedicineBusyMode mode;

  @override
  State<MedicineDetailsOverlay> createState() => _MedicineDetailsOverlayState();
}

class _MedicineDetailsOverlayState extends State<MedicineDetailsOverlay>
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
  void didUpdateWidget(MedicineDetailsOverlay old) {
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
