import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class BaseToolButton extends StatelessWidget {
  final String iconPath;
  final bool isSelected;
  final bool isHovering;
  final bool useAccentColor;
  final VoidCallback? onTap;

  const BaseToolButton({
    super.key,
    required this.iconPath,
    required this.isSelected,
    required this.isHovering,
    this.useAccentColor = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        margin: const EdgeInsets.all(AppSizes.toolButtonMargin),
        padding: const EdgeInsets.all(AppSizes.toolButtonPadding),
        duration: AppSizes.animationDuration,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(AppSizes.toolButtonBorderRadius),
        ),
        child: Image.asset(
          iconPath,
          width: AppSizes.toolButtonSize,
          height: AppSizes.toolButtonSize,
          color: (useAccentColor && isSelected) ? AppColors.iconPurple : null,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isSelected) {
      return useAccentColor ? AppColors.selectedPurple : AppColors.selectedGrey;
    }
    return isHovering ? AppColors.hoverGrey : Colors.white;
  }
}
