import 'package:flutter/material.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/tool_item.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)],
      ),
      child: Column(
        children: [
          ToolItem(image: 'assets/icons/selection.png', message: 'select'),
          ToolItem(image: 'assets/icons/pencil.png', message: 'Draw'),
          ToolItem(image: 'assets/icons/shapes.png', message: 'shapes'),
          ToolItem(image: 'assets/icons/arrow-right.png', message: 'lines'),
          ToolItem(
            image: 'assets/icons/sticky-notes.png',
            message: 'sticky notes',
          ),
          ToolItem(image: 'assets/icons/text-box.png', message: 'Text'),
          ToolItem(image: 'assets/icons/table.png', message: 'Table'),
        ],
      ),
    );
  }
}
