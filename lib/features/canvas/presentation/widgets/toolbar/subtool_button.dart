import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/core/widgets/base_tool_button.dart';
import 'package:vivid_canvas/core/widgets/custom_tooltip.dart';
import 'package:vivid_canvas/core/widgets/tooltip_wrapper.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/tool_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/ui_state_provider.dart';

import '../../../domain/models/sub_tool_config.dart';
import '../../../domain/models/drawing_tool_type.dart';
import '../../providers/drawing_state_provider.dart';

class SubToolButton extends ConsumerWidget {
  final SubToolConfig subTool;
  final VoidCallback? onTap;
  final bool isHorizontal;

  const SubToolButton({super.key, required this.subTool, this.onTap, this.isHorizontal = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolState = ref.watch(toolStateProvider);
    final isSelected = toolState.isSubToolSelected(subTool);
    final isHovering = toolState.isHovering(subTool.iconPath);

    return MouseRegion(
      onEnter: (_) =>
          ref.read(toolStateProvider.notifier).setHover(subTool.iconPath, true),
      onExit: (_) => ref
          .read(toolStateProvider.notifier)
          .setHover(subTool.iconPath, false),
      child: isHovering
          ? TooltipWrapper(
              message: subTool.label,
              tooltipSide: isHorizontal ? TooltipSide.top : TooltipSide.left,
              child: _buildButton(ref, isSelected, isHovering),
            )
          : _buildButton(ref, isSelected, isHovering),
    );
  }

  Widget _buildButton(WidgetRef ref, bool isSelected, bool isHovering) {
    return BaseToolButton(
      iconPath: subTool.iconPath,
      isSelected: isSelected,
      isHovering: isHovering,
      onTap: onTap ?? () => _handleTap(ref),
    );
  }

  void _handleTap(WidgetRef ref) {
    ref.read(toolStateProvider.notifier).selectSubTool(subTool);
    
    // Auto-Deselect on Tool Change
    ref.read(drawingStateProvider.notifier).deselectPath();

    final toolTypeMap = {
      'Pen': DrawingToolType.pen,
      'Marker': DrawingToolType.marker,
      'Highlighter': DrawingToolType.highlighter,
      'Eraser': DrawingToolType.eraser,
      'Circle': DrawingToolType.circle,
      'Rectangle': DrawingToolType.rectangle,
      'Rounded Rectangle': DrawingToolType.roundedRectangle,
      'Triangle': DrawingToolType.triangle,
      'Down Triangle': DrawingToolType.downTriangle,
      'Asterisk': DrawingToolType.asterisk,
      'Heart': DrawingToolType.heart,
      'Hexagonal': DrawingToolType.hexagonal,
    };

    if (toolTypeMap.containsKey(subTool.label)) {
      ref
          .read(drawingStateProvider.notifier)
          .changeToolType(toolTypeMap[subTool.label]!);
    }

    // Close UI panels
    ref.read(uiStateProvider.notifier).closeAllPanels();
  }
}
