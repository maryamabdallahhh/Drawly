import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/canvas_grid.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/tool_bar.dart';

class WhiteboardScreen extends ConsumerStatefulWidget {
  const WhiteboardScreen({super.key});

  @override
  ConsumerState<WhiteboardScreen> createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends ConsumerState<WhiteboardScreen> {
  late TransformationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //   INFINITE BACKGROUND DOTS
          ValueListenableBuilder<Matrix4>(
            valueListenable: _controller,
            builder: (context, matrix, _) {
              return Positioned.fill(
                child: CustomPaint(painter: InfiniteGridPainter(matrix)),
              );
            },
          ),
          Positioned(top: 50, left: 100, child: ToolBar()),
        ],
      ),
    );
  }
}
