// Updated SubToolItem using the unified widget
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/core/constants/tool_constants.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/interactive_tool_item.dart';
import 'package:vivid_canvas/features/canvas/providers/canvas_providers.dart';

class SubToolItem extends ConsumerWidget {
  final String image;
  final String message;

  const SubToolItem({super.key, required this.image, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InteractiveToolItem(
      image: image,
      message: message,
      isSubTool: true,
      onTap: () => ref.read(selectedSubToolProvider.notifier).state = message,
      tooltipPosition: TooltipPosition.left,
    );
  }
}
