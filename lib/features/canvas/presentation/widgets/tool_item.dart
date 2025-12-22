import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/providers/canvas_providers.dart';

class ToolItem extends ConsumerWidget {
  final String image;
  final String message;

  const ToolItem({super.key, required this.image, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovering = ref.watch(hoverStateProvider(image));
    final selectedTool = ref.watch(selectedToolProvider);
    final isSelected = selectedTool == image;
    final isSelectionTool = image == 'assets/icons/selection.png';

    return MouseRegion(
      onEnter: (_) => ref.read(hoverStateProvider(image).notifier).state = true,
      onExit: (_) => ref.read(hoverStateProvider(image).notifier).state = false,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Icon with hover container
          GestureDetector(
            onTap: () {
              // Update the selected tool when tapped
              ref.read(selectedToolProvider.notifier).state = image;
            },
            child: AnimatedContainer(
              margin: EdgeInsets.all(4),
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isSelectionTool
                          ? Color(0xFFF2EAFF) // Purple for selection tool
                          : Color(0xffE1E4E7)) // Grey for other tools
                    : (isHovering ? Color(0xffF2F3F5) : Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                image,
                width: 24,
                height: 24,
                color: (isSelectionTool && isSelected)
                    ? Color(0xff612DAE)
                    : null,
              ),
            ),
          ),

          // Tooltip that appears to the right
          if (isHovering)
            Positioned(
              left: 50,
              top: 8,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: isHovering ? 1.0 : 0.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
