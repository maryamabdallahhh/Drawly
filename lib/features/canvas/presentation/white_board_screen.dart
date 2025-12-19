import 'package:flutter/material.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/canvas_grid.dart';

class WhiteboardScreen extends StatefulWidget {
  const WhiteboardScreen({super.key});

  @override
  State<WhiteboardScreen> createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  final TransformationController _controller = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // THE BACKGROUND: Always stays full-screen, but dots move
          ValueListenableBuilder<Matrix4>(
            valueListenable: _controller,
            builder: (context, matrix, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: InfiniteGridPainter(matrix),
              );
            },
          ),

          // THE INTERACTIVE LAYER: Where your sticky notes and drawings go
          InteractiveViewer(
            transformationController: _controller,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(
              double.infinity,
            ), // Allow infinite panning
            minScale: 0.1,
            maxScale: 5.0,
            child: SizedBox(
              width: 10000, // Make this huge so you don't hit "walls"
              height: 10000,
              // We leave this transparent so we see the painter behind it
            ),
          ),
        ],
      ),
    );
  }
}
