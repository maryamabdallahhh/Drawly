// features/canvas/presentation/widgets/tool_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/core/constants/tool_constants.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/sub_tool_item.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/tool_item.dart';
import 'package:vivid_canvas/features/canvas/providers/canvas_providers.dart';

class ToolBar extends ConsumerWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTool = ref.watch(selectedToolProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainToolbar(ref),
        if (_shouldShowSubmenu(selectedTool)) ...[
          SizedBox(width: 8),
          _buildSubmenu(selectedTool),
        ],
      ],
    );
  }

  /// Builds the main toolbar with all primary tools
  Widget _buildMainToolbar(WidgetRef ref) {
    return Container(
      width: ToolItemConstants.toolbarWidth,
      decoration: _toolbarDecoration(),
      child: Column(
        children: ToolType.values.map((toolType) {
          return ToolItem(
            image: toolType.assetPath,
            message: toolType.label,
            onTap: () => _handleToolTap(ref, toolType.assetPath),
          );
        }).toList(),
      ),
    );
  }

  /// Builds the submenu for tools that have sub-options
  Widget _buildSubmenu(String selectedTool) {
    final submenuItems = ToolSubmenuConfig.getSubmenuFor(selectedTool);

    if (submenuItems == null || submenuItems.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      width: ToolItemConstants.toolbarWidth,
      decoration: _toolbarDecoration(),
      child: Column(
        children: submenuItems.map((config) {
          return SubToolItem(image: config.assetPath, message: config.label);
        }).toList(),
      ),
    );
  }

  /// Standard decoration for toolbar containers
  BoxDecoration _toolbarDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(ToolItemConstants.borderRadius),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 2),
      ],
    );
  }

  /// Checks if the selected tool should display a submenu
  bool _shouldShowSubmenu(String selectedTool) {
    final toolType = ToolType.values.firstWhere(
      (t) => t.assetPath == selectedTool,
      orElse: () => ToolType.selection,
    );
    return toolType.hasSubmenu;
  }

  /// Handles tool selection with toggle behavior
  void _handleToolTap(WidgetRef ref, String toolImage) {
    final currentTool = ref.read(selectedToolProvider);

    if (currentTool == toolImage) {
      // Toggle off: return to selection tool
      ref.read(selectedToolProvider.notifier).state =
          ToolType.selection.assetPath;
      ref.read(selectedSubToolProvider.notifier).state = null;
    } else {
      // Select new tool
      ref.read(selectedToolProvider.notifier).state = toolImage;
      ref.read(selectedSubToolProvider.notifier).state = null;
    }
  }
}
