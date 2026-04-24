import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/core/constants/app_colors.dart';
import '../../providers/drawing_state_provider.dart';

class DrawingSettingsPanel extends ConsumerWidget {
  const DrawingSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strokeWidth = ref.watch(drawingStateProvider.select((s) => s.settings.strokeWidth));
    
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
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stroke Size: ${strokeWidth.toInt()}px',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.iconPurple,
              thumbColor: AppColors.iconPurple,
              overlayColor: AppColors.iconPurple.withValues(alpha: 0.2),
              trackHeight: 4,
            ),
            child: Slider(
              value: strokeWidth,
              min: 1.0,
              max: 50.0,
              onChanged: (val) {
                ref.read(drawingStateProvider.notifier).updateStrokeWidth(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
