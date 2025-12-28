import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/toolbar/toolbar_widget.dart';
import '../widgets/canvas/canvas_widget.dart';

class WhiteboardScreen extends ConsumerWidget {
  const WhiteboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Stack(
        children: [
          // Main canvas area
          Positioned.fill(child: CanvasWidget()),

          // Toolbar overlay
          Positioned(
            top: 50,
            left: 100,
            child: IgnorePointer(ignoring: false, child: ToolbarWidget()),
          ),
        ],
      ),
    );
  }
}
