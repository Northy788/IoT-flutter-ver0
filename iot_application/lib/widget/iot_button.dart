import 'package:flutter/material.dart';

class iotButton extends StatelessWidget {
  const iotButton({
    super.key,
    required this.ledState,
    required this.toggle,
  });

  final IconData ledState;
  final Function() toggle;
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: toggle,
      icon: Icon(
        ledState,
        color: Colors.grey,
        size: 80,
      ),
      label: const Text(
        "LED",
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      style: TextButton.styleFrom(
        side: const BorderSide(
          color: Colors.grey,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
