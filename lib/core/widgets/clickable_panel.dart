import 'package:flutter/material.dart';

class ClickablePanel extends StatelessWidget {
  final Widget child;

  const ClickablePanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {}, // Absorb taps
        child: child,
      ),
    );
  }
}
