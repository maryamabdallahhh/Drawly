import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/core/constants/app_colors.dart';
import 'package:vivid_canvas/core/constants/app_sizes.dart';
import 'package:vivid_canvas/core/widgets/clickable_panel.dart';
import 'package:vivid_canvas/core/widgets/panel_container.dart';
import 'package:vivid_canvas/features/canvas/domain/models/drawing_settings.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/drawing_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/ui_state_provider.dart';

import '../../../../../core/constants/app_strings.dart';

class DrawingSettingsPanel extends ConsumerWidget {
  const DrawingSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawingState = ref.watch(drawingStateProvider);
    final settings = drawingState.settings;
    final isEraser = settings.toolType.isEraser;

    return ClickablePanel(
      child: PanelContainer(
        width: AppSizes.settingsPanelWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEraser ? AppStrings.weight : AppStrings.drawingSettings,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () =>
                        ref.read(uiStateProvider.notifier).closeSettingsPanel(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stroke Width
            Text(
              '${AppStrings.strokeWidth}: ${settings.strokeWidth.toInt()}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.iconPurple,
                thumbColor: AppColors.iconPurple,
                overlayColor: AppColors.iconPurple.withOpacity(0.2),
              ),
              child: Slider(
                value: settings.strokeWidth,
                min: AppSizes.minStrokeWidth,
                max: AppSizes.maxStrokeWidth,
                divisions: AppSizes.strokeWidthDivisions,
                onChanged: (value) => ref
                    .read(drawingStateProvider.notifier)
                    .updateStrokeWidth(value),
              ),
            ),

            // Opacity - ONLY for non-eraser tools
            if (!isEraser) ...[
              const SizedBox(height: 12),
              Text(
                '${AppStrings.opacity}: ${(settings.opacity * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.iconPurple,
                  thumbColor: AppColors.iconPurple,
                  overlayColor: AppColors.iconPurple.withOpacity(0.2),
                ),
                child: Slider(
                  value: settings.opacity,
                  min: AppSizes.minOpacity,
                  max: AppSizes.maxOpacity,
                  divisions: AppSizes.opacityDivisions,
                  onChanged: (value) => ref
                      .read(drawingStateProvider.notifier)
                      .updateOpacity(value),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Preview
            const Text(
              AppStrings.preview,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: _PreviewPainter(settings),
                size: const Size(double.infinity, 60),
              ),
            ),

            if (isEraser) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange[700],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        AppStrings.eraserInfo,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PreviewPainter extends CustomPainter {
  final DrawingSettings settings;

  _PreviewPainter(this.settings);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = settings.toolType.isEraser
        ? (Paint()
            ..color = Colors.grey[400]!
            ..strokeWidth = settings.strokeWidth
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke)
        : settings.toPaint();

    final path = Path();
    path.moveTo(20, size.height / 2);
    path.quadraticBezierTo(
      size.width / 2,
      size.height / 4,
      size.width - 20,
      size.height / 2,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PreviewPainter oldDelegate) => true;
}
