import 'package:flutter/material.dart';

class AnimatedSliverRecordItem extends StatefulWidget {
  const AnimatedSliverRecordItem({
    super.key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 720),
    this.maxStaggerDelay = const Duration(milliseconds: 420),
    this.staggerStep = const Duration(milliseconds: 300),
    this.beginOffset = const Offset(0, 0.14),
  });

  final int index;
  final Widget child;
  final Duration duration;
  final Duration maxStaggerDelay;
  final Duration staggerStep;
  final Offset beginOffset;

  @override
  State<AnimatedSliverRecordItem> createState() =>
      _AnimatedSliverRecordItemState();
}

class _AnimatedSliverRecordItemState extends State<AnimatedSliverRecordItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(curved);
    _slide = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(curved);

    final staggerMs = widget.staggerStep.inMilliseconds * widget.index;
    final maxDelayMs = widget.maxStaggerDelay.inMilliseconds;
    final delay = Duration(milliseconds: staggerMs.clamp(0, maxDelayMs));

    Future<void>.delayed(delay, () {
      if (!mounted) return;
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
