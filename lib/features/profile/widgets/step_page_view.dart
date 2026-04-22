import 'package:flutter/material.dart';

class StepPageView extends StatelessWidget {
  final PageController controller;
  final List<Widget> children;
  final double height;

  const StepPageView({
    super.key,
    required this.controller,
    required this.children,
    this.height = 450,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: children,
      ),
    );
  }
}
