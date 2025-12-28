import 'package:flutter/material.dart';

enum TooltipSide { left, right, top, bottom }

class CustomTooltip extends StatelessWidget {
  final String message;
  final TooltipSide side;
  final double offset;

  const CustomTooltip({
    super.key,
    required this.message,
    this.side = TooltipSide.right,
    this.offset = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
