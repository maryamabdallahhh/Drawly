import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../theme/app_theme.dart';

class PanelContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final EdgeInsets? padding;

  const PanelContainer({
    super.key,
    required this.child,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? const EdgeInsets.all(AppSizes.panelPadding),
      decoration: BoxDecoration(
        color: AppColors.panelBackground,
        borderRadius: BorderRadius.circular(AppSizes.panelBorderRadius),
        boxShadow: AppTheme.panelShadow,
      ),
      child: child,
    );
  }
}
