import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/domain/models/sub_tool_config.dart';
import 'package:vivid_canvas/features/canvas/domain/models/tool_config.dart';
import 'package:vivid_canvas/features/canvas/presentation/providers/canvas_state_provider.dart';

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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MainToolbar(),
        if (subTools != null && subTools.isNotEmpty) ...[
          const SizedBox(width: AppSizes.toolbarSpacing),
          _SubToolbar(subTools: subTools),
        ],
      ],
    );
  }
}

/// Main toolbar with primary tools
class _MainToolbar extends StatelessWidget {
  const _MainToolbar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.toolbarWidth,
      decoration: _toolbarDecoration(),
      child: Column(
        children: ToolType.values
            .map((tool) => ToolButton(tool: tool))
            .toList(),
      ),
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

  const _SubToolbar({required this.subTools});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTool = ref.watch(currentToolProvider);
    final isDrawingTool = currentTool == ToolType.pencil;

    return Container(
      width: AppSizes.toolbarWidth,
      decoration: _toolbarDecoration(),
      child: Column(
        children: [
          ...subTools
              .map((subTool) => SubToolButton(subTool: subTool))
              .toList(),

          // Drawing-specific indicators
          if (isDrawingTool) ...[
            const Divider(height: 1),
            const ColorIndicatorWidget(),
            const StrokeIndicatorWidget(),
          ],
        ],
      ),
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
