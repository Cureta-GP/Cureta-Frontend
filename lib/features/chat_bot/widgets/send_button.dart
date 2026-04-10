import 'package:flutter/material.dart';

/// Circular send button used in the chat input bar.
class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.onPressed,
    required this.radius,
    required this.color,
  });

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Corner radius for the button shape.
  final double radius;

  /// Background fill colour.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: const Center(
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
