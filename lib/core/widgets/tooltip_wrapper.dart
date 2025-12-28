import 'package:flutter/material.dart';
import 'custom_tooltip.dart';
import '../constants/app_sizes.dart';

class TooltipWrapper extends StatelessWidget {
  final Widget child;
  final String message;
  final TooltipSide tooltipSide;

  const TooltipWrapper({
    super.key,
    required this.child,
    required this.message,
    this.tooltipSide = TooltipSide.right,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          left: tooltipSide == TooltipSide.left ? AppSizes.tooltipOffset : null,
          right: tooltipSide == TooltipSide.right
              ? AppSizes.tooltipOffset
              : null,
          top: [TooltipSide.left, TooltipSide.right].contains(tooltipSide)
              ? 8
              : null,
          bottom: tooltipSide == TooltipSide.bottom
              ? AppSizes.tooltipOffset
              : null,
          child: AnimatedOpacity(
            duration: AppSizes.animationDuration,
            opacity: 1.0,
            child: CustomTooltip(message: message, side: tooltipSide),
          ),
        ),
      ],
    );
  }
}
