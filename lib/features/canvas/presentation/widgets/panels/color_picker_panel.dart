import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/core/constants/app_colors.dart';
import '../../providers/drawing_state_provider.dart';

class ColorPickerPanel extends ConsumerWidget {
  const ColorPickerPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentColor = ref.watch(
      drawingStateProvider.select((s) => s.settings.color),
    );

    final colors = <Color>{
      ...AppColors.penColors,
      ...AppColors.markerColors,
      ...AppColors.highlighterColors,
    }.toList(); // unique colors

    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.panelBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.panelShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: colors.map((color) {
          final isSelected = color == currentColor;
          return GestureDetector(
            onTap: () =>
                ref.read(drawingStateProvider.notifier).updateColor(color),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.hoverGrey : Colors.black12,
                  width: isSelected ? 3 : 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
