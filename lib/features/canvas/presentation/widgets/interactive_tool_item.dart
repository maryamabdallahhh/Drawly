import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/core/constants/tool_constants.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/tool_tip.dart';
import 'package:vivid_canvas/features/canvas/providers/canvas_providers.dart';

class InteractiveToolItem extends ConsumerWidget {
  final String image;
  final String message;
  final VoidCallback? onTap;
  final bool isSubTool;
  final TooltipPosition tooltipPosition;

  const InteractiveToolItem({
    super.key,
    required this.image,
    required this.message,
    this.onTap,
    this.isSubTool = false,
    this.tooltipPosition = TooltipPosition.right,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovering = ref.watch(hoverStateProvider(image));
    final isSelected = _isSelected(ref);
    final isSelectionTool = image == ToolType.selection.assetPath;

    return MouseRegion(
      onEnter: (_) => ref.read(hoverStateProvider(image).notifier).state = true,
      onExit: (_) => ref.read(hoverStateProvider(image).notifier).state = false,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildToolButton(isSelected, isHovering, isSelectionTool),
          if (isHovering) _buildTooltip(),
        ],
      ),
    );
  }

  Widget _buildToolButton(
    bool isSelected,
    bool isHovering,
    bool isSelectionTool,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        margin: EdgeInsets.all(ToolItemConstants.itemMargin),
        duration: ToolItemConstants.animationDuration,
        padding: EdgeInsets.all(ToolItemConstants.itemPadding),
        decoration: BoxDecoration(
          color: _getBackgroundColor(isSelected, isHovering, isSelectionTool),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          image,
          width: ToolItemConstants.itemSize,
          height: ToolItemConstants.itemSize,
          color: (isSelectionTool && isSelected)
              ? ToolItemConstants.iconPurple
              : null,
        ),
      ),
    );
  }

  Widget _buildTooltip() {
    return Positioned(
      left: tooltipPosition == TooltipPosition.left ? 50 : null,
      right: tooltipPosition == TooltipPosition.right ? 50 : null,
      top: 8,
      child: AnimatedOpacity(
        duration: ToolItemConstants.animationDuration,
        opacity: 1.0,
        child: ToolTooltip(message: message),
      ),
    );
  }

  bool _isSelected(WidgetRef ref) {
    if (isSubTool) {
      final selectedSubTool = ref.watch(selectedSubToolProvider);
      return selectedSubTool == message;
    } else {
      final selectedTool = ref.watch(selectedToolProvider);
      return selectedTool == image;
    }
  }

  Color _getBackgroundColor(
    bool isSelected,
    bool isHovering,
    bool isSelectionTool,
  ) {
    if (isSelected) {
      return isSelectionTool
          ? ToolItemConstants.selectedPurple
          : ToolItemConstants.selectedGrey;
    }
    return isHovering ? ToolItemConstants.hoverGrey : Colors.white;
  }
}
