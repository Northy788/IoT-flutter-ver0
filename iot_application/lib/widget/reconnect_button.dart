import 'package:flutter/material.dart';

class reconnectButton extends StatelessWidget {
  const reconnectButton({
    super.key,
    required this.connecting,
  });

  final Function() connecting;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: connecting,
      child: const Text("CONNECT"),
    );
  }
}
