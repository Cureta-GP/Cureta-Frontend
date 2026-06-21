import 'package:flutter/material.dart';

class StepPageView extends StatelessWidget {
  final PageController controller;
  final List<Widget> children;

  const StepPageView({
    super.key,
    required this.controller,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}
