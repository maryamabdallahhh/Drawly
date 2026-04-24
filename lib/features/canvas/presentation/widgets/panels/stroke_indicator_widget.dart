import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ui_state_provider.dart';
import '../../providers/drawing_state_provider.dart';

class StrokeIndicatorWidget extends ConsumerWidget {
  final bool isHorizontal;
  const StrokeIndicatorWidget({super.key, this.isHorizontal = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strokeWidth = ref.watch(drawingStateProvider.select((s) => s.settings.strokeWidth));
    
    return GestureDetector(
      onTap: () {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final offset = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;
          if (isHorizontal) {
            // Position above the button and centered horizontally
            ref.read(uiStateProvider.notifier).toggleSettingsPanel(
              Offset(offset.dx - 130 + (size.width / 2), offset.dy - 150)
            );
          } else {
            // Position right next to the button, vertically aligned with it
            ref.read(uiStateProvider.notifier).toggleSettingsPanel(
              Offset(offset.dx + size.width + 16, offset.dy - 10)
            );
          }
        } else {
          ref.read(uiStateProvider.notifier).toggleSettingsPanel();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Container(
          width: strokeWidth.clamp(2.0, 20.0),
          height: strokeWidth.clamp(2.0, 20.0),
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
