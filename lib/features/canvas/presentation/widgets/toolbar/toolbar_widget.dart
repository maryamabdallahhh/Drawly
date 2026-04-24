import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/domain/models/sub_tool_config.dart';
import 'package:vivid_canvas/features/canvas/domain/models/tool_config.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/drawing_state_provider.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/models/tool_type.dart';
import 'tool_button.dart';
import 'subtool_button.dart';
import '../panels/color_indicator_widget.dart';
import '../panels/stroke_indicator_widget.dart';

class ToolbarWidget extends ConsumerWidget {
  const ToolbarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTool = ref.watch(currentToolProvider);
    final subTools = ToolConfigurations.getSubmenuFor(currentTool);
    final isMobile = MediaQuery.sizeOf(context).width < 800;

    if (isMobile) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (subTools != null && subTools.isNotEmpty) ...[
            _SubToolbar(subTools: subTools, isHorizontal: true),
            const SizedBox(height: AppSizes.toolbarSpacing),
          ],
          const _MainToolbar(isHorizontal: true),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MainToolbar(isHorizontal: false),
        if (subTools != null && subTools.isNotEmpty) ...[
          const SizedBox(width: AppSizes.toolbarSpacing),
          _SubToolbar(subTools: subTools, isHorizontal: false),
        ],
      ],
    );
  }
}

/// Main toolbar with primary tools
class _MainToolbar extends StatelessWidget {
  final bool isHorizontal;
  
  const _MainToolbar({required this.isHorizontal});

  @override
  Widget build(BuildContext context) {
    final children = ToolType.values
        .map((tool) => ToolButton(tool: tool, isHorizontal: isHorizontal))
        .toList();

    return Container(
      width: isHorizontal ? null : AppSizes.toolbarWidth,
      height: isHorizontal ? AppSizes.toolbarWidth : null,
      decoration: _toolbarDecoration(),
      child: isHorizontal
          ? Row(mainAxisSize: MainAxisSize.min, children: children)
          : Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  BoxDecoration _toolbarDecoration() {
    return BoxDecoration(
      color: AppColors.toolbarBackground,
      borderRadius: BorderRadius.circular(AppSizes.toolbarBorderRadius),
      boxShadow: AppTheme.toolbarShadow,
    );
  }
}

/// Submenu toolbar with context-specific tools
class _SubToolbar extends ConsumerWidget {
  final List<SubToolConfig> subTools;
  final bool isHorizontal;

  const _SubToolbar({required this.subTools, required this.isHorizontal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTool = ref.watch(currentToolProvider);
    final isDrawingTool = currentTool == ToolType.pencil;
    final isEraser = ref.watch(drawingStateProvider.select((s) => s.settings.toolType.isEraser));

    final children = <Widget>[
      ...subTools.map((subTool) => SubToolButton(subTool: subTool, isHorizontal: isHorizontal)),
      // Drawing-specific indicators
      if (isDrawingTool) ...[
        if (isHorizontal) const VerticalDivider(width: 1) else const Divider(height: 1),
        if (!isEraser) ColorIndicatorWidget(isHorizontal: isHorizontal),
        StrokeIndicatorWidget(isHorizontal: isHorizontal),
      ],
    ];

    return Container(
      width: isHorizontal ? null : AppSizes.toolbarWidth,
      height: isHorizontal ? AppSizes.toolbarWidth : null,
      decoration: _toolbarDecoration(),
      child: isHorizontal
          ? Row(mainAxisSize: MainAxisSize.min, children: children)
          : Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  BoxDecoration _toolbarDecoration() {
    return BoxDecoration(
      color: AppColors.toolbarBackground,
      borderRadius: BorderRadius.circular(AppSizes.toolbarBorderRadius),
      boxShadow: AppTheme.toolbarShadow,
    );
  }
}
