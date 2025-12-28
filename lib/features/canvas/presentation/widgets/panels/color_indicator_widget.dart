import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../providers/drawing_state_provider.dart';
import '../../providers/ui_state_provider.dart';
import 'color_picker_panel.dart';

class ColorIndicatorWidget extends ConsumerWidget {
  const ColorIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(drawingStateProvider).settings;
    final isEraser = settings.toolType.isEraser;
    final showColorPicker = ref.watch(uiStateProvider).showColorPicker;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Current color circle button
        MouseRegion(
          cursor: isEraser
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: isEraser
                ? null
                : () => ref.read(uiStateProvider.notifier).toggleColorPicker(),
            child: Container(
              width: AppSizes.colorIndicatorSize,
              height: AppSizes.colorIndicatorSize,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: settings.color,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderColor, width: 2),
              ),
            ),
          ),
        ),

        // Color palette popup
        if (showColorPicker && !isEraser)
          const Positioned(left: 70, top: -10, child: ColorPickerPanel()),
      ],
    );
  }
}
