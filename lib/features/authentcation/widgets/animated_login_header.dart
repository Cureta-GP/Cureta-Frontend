import 'package:cureta/features/authentcation/veiw_model/rive_animation_manager.dart';
import 'package:cureta/features/authentcation/widgets/login_header.dart';
import 'package:flutter/material.dart';

class AnimatedLoginHeader extends StatefulWidget {
  final RiveAnimationManager animationManager;

  const AnimatedLoginHeader({
    super.key,
    required this.animationManager,
  });

  @override
  State<AnimatedLoginHeader> createState() => _AnimatedLoginHeaderState();
}

class _AnimatedLoginHeaderState extends State<AnimatedLoginHeader> {
  @override
  void initState() {
    super.initState();
    widget.animationManager.addListener(_onArtboardChanged);
  }

  void _onArtboardChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.animationManager.removeListener(_onArtboardChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginHeader(riveArtboard: widget.animationManager.artboard);
  }
}