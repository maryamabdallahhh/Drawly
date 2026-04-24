import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/ui_state_provider.dart';
import '../../providers/drawing_state_provider.dart';

class ColorIndicatorWidget extends ConsumerWidget {
  const ColorIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(drawingStateProvider.select((s) => s.settings.color));
    
    return GestureDetector(
      onTap: () {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final offset = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;
          // Position right next to the button, vertically aligned with it
          ref.read(uiStateProvider.notifier).toggleColorPicker(
            Offset(offset.dx + size.width + 16, offset.dy - 10)
          );
        } else {
          ref.read(uiStateProvider.notifier).toggleColorPicker();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 2),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
      ),
    );
  }
}
