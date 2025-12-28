import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/widgets/base_tool_button.dart';
import '../../../../../core/widgets/tooltip_wrapper.dart';
import '../../../../../core/widgets/custom_tooltip.dart';
import '../../../domain/models/tool_type.dart';
import '../../providers/tool_state_provider.dart';
import '../../providers/ui_state_provider.dart';

class ToolButton extends ConsumerWidget {
  final ToolType tool;
  final VoidCallback? onTap;

  const ToolButton({super.key, required this.tool, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolState = ref.watch(toolStateProvider);
    final isSelected = toolState.isToolSelected(tool);
    final isHovering = toolState.isHovering(tool.iconPath);

    return MouseRegion(
      onEnter: (_) =>
          ref.read(toolStateProvider.notifier).setHover(tool.iconPath, true),
      onExit: (_) =>
          ref.read(toolStateProvider.notifier).setHover(tool.iconPath, false),
      child: isHovering
          ? TooltipWrapper(
              message: tool.label,
              tooltipSide: TooltipSide.right,
              child: _buildButton(ref, isSelected, isHovering),
            )
          : _buildButton(ref, isSelected, isHovering),
    );
  }

  Widget _buildButton(WidgetRef ref, bool isSelected, bool isHovering) {
    return BaseToolButton(
      iconPath: tool.iconPath,
      isSelected: isSelected,
      isHovering: isHovering,
      useAccentColor: tool == ToolType.selection,
      onTap: onTap ?? () => _handleTap(ref),
    );
  }

  void _handleTap(WidgetRef ref) {
    ref.read(toolStateProvider.notifier).selectTool(tool);
    ref.read(uiStateProvider.notifier).closeAllPanels();
  }
}
