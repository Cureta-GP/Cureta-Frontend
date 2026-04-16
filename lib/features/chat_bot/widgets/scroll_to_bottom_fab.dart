import 'package:flutter/material.dart';

class ScrollToBottomFab extends StatefulWidget {
  const ScrollToBottomFab({
    super.key,
    required this.isVisible,
    required this.onPressed,
  });

  final bool isVisible;
  final VoidCallback onPressed;

  @override
  State<ScrollToBottomFab> createState() => _ScrollToBottomFabState();
}

class _ScrollToBottomFabState extends State<ScrollToBottomFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    if (widget.isVisible) {
      _floatController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ScrollToBottomFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible == widget.isVisible) {
      return;
    }

    if (widget.isVisible) {
      _floatController.repeat(reverse: true);
    } else {
      _floatController
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      right: 16,
      bottom: 16,
      child: IgnorePointer(
        ignoring: !widget.isVisible,
        child: AnimatedSlide(
          offset: widget.isVisible ? Offset.zero : const Offset(0, 0.4),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: widget.isVisible ? 1 : 0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                final double dy = widget.isVisible
                    ? -3.0 * _floatController.value
                    : 0.0;
                return Transform.translate(offset: Offset(0, dy), child: child);
              },
              child: FloatingActionButton.small(
                onPressed: widget.onPressed,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 2,
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
