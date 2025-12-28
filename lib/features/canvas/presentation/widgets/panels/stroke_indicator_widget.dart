import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/drawing_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/ui_state_provider.dart';

import '../../../../../core/constants/app_colors.dart';
import 'drawing_settings_panel.dart';

class StrokeIndicatorWidget extends ConsumerWidget {
  const StrokeIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(drawingStateProvider).settings;
    final showSettings = ref.watch(uiStateProvider).showSettingsPanel;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () =>
                ref.read(uiStateProvider.notifier).toggleSettingsPanel(),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: showSettings ? Colors.grey[100] : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: showSettings
                      ? AppColors.iconPurple
                      : AppColors.borderColor,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.line_weight,
                    size: 20,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${settings.strokeWidth.toInt()}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (showSettings)
          const Positioned(left: 65, top: -20, child: DrawingSettingsPanel()),
      ],
    );
  }
}
