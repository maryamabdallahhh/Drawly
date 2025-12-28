import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/domain/models/drawing_tool_type.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/drawing_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/ui_state_provider.dart';
import '../../../../../core/widgets/clickable_panel.dart';
import '../../../../../core/widgets/panel_container.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';

class ColorPickerPanel extends ConsumerWidget {
  const ColorPickerPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawingState = ref.watch(drawingStateProvider);
    final settings = drawingState.settings;
    final toolType = settings.toolType;
    final palette = _getColorPaletteForTool(toolType);
    final documentColors = drawingState.documentColors;

    return ClickablePanel(
      child: PanelContainer(
        width: AppSizes.colorPaletteWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tool-specific colors section
            Row(
              children: [
                const Icon(Icons.palette, size: 18),
                const SizedBox(width: 8),
                Text(
                  palette.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: AppSizes.colorCircleSpacing,
              runSpacing: AppSizes.colorCircleSpacing,
              children: palette.colors
                  .map(
                    (color) => _buildColorCircle(
                      ref,
                      color,
                      settings.color.value == color.value,
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Document colors section
            const Row(
              children: [
                Icon(Icons.description_outlined, size: 18),
                SizedBox(width: 8),
                Text(
                  AppStrings.documentColors,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: AppSizes.colorCircleSpacing,
              runSpacing: AppSizes.colorCircleSpacing,
              children: [
                // Add color button
                _buildAddColorButton(context, ref, settings),
                // Document colors
                ...documentColors.map(
                  (color) => _buildColorCircle(
                    ref,
                    color,
                    settings.color.value == color.value,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Text(
              AppStrings.noBrandColors,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(WidgetRef ref, Color color, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ref.read(drawingStateProvider.notifier).updateColor(color);
          ref.read(uiStateProvider.notifier).closeColorPicker();
        },
        child: Container(
          width: AppSizes.colorCircleSize,
          height: AppSizes.colorCircleSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.black : AppColors.borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: isSelected
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : null,
        ),
      ),
    );
  }

  Widget _buildAddColorButton(BuildContext context, WidgetRef ref, settings) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showColorPickerDialog(context, ref, settings),
        child: Container(
          width: AppSizes.colorCircleSize,
          height: AppSizes.colorCircleSize,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.purple,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context, WidgetRef ref, settings) {
    Color pickerColor = settings.color;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.pickColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) {
              pickerColor = color;
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(drawingStateProvider.notifier)
                  .addDocumentColor(pickerColor);
              ref.read(drawingStateProvider.notifier).updateColor(pickerColor);
              Navigator.pop(context);
            },
            child: const Text(AppStrings.add),
          ),
        ],
      ),
    );
  }

  _ColorPalette _getColorPaletteForTool(DrawingToolType toolType) {
    switch (toolType) {
      case DrawingToolType.pen:
        return _ColorPalette(
          title: AppStrings.penColors,
          colors: AppColors.penColors,
        );
      case DrawingToolType.marker:
        return const _ColorPalette(
          title: AppStrings.markerColors,
          colors: AppColors.markerColors,
        );
      case DrawingToolType.highlighter:
        return const _ColorPalette(
          title: AppStrings.highlighterColors,
          colors: AppColors.highlighterColors,
        );
      case DrawingToolType.eraser:
        return const _ColorPalette(title: '', colors: []);
    }
  }
}

class _ColorPalette {
  final String title;
  final List<Color> colors;

  const _ColorPalette({required this.title, required this.colors});
}
