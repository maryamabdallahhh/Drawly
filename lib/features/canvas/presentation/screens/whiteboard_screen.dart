import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/panels/color_picker_panel.dart';
import 'package:vivid_canvas/features/canvas/presentation/widgets/panels/drawing_settings_panel.dart';

import '../widgets/toolbar/toolbar_widget.dart';
import '../widgets/canvas/canvas_widget.dart';
import '../providers/ui_state_provider.dart';
import '../providers/drawing_state_provider.dart';

class WhiteboardScreen extends ConsumerWidget {
  const WhiteboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(uiStateProvider);
    final isEraser = ref.watch(drawingStateProvider.select((s) => s.settings.toolType.isEraser));
    final isMobile = MediaQuery.sizeOf(context).width < 800;

    return Scaffold(
      body: Stack(
        children: [
          // Main canvas area (BOTTOM LAYER)
          const Positioned.fill(child: CanvasWidget()),

          // Toolbar overlay (MIDDLE LAYER)
          Positioned(
            top: isMobile ? null : 50,
            bottom: isMobile ? 20 : null,
            left: isMobile ? 0 : 100,
            right: isMobile ? 0 : null,
            child: const ToolbarWidget(),
          ),

          // ✅ PANELS AT ROOT LEVEL (TOP LAYER) - Better gesture isolation
          // Color Picker Panel
          if (uiState.showColorPicker && !isEraser)
            Positioned(
              top: uiState.panelPosition?.dy ?? 50,
              left: uiState.panelPosition?.dx ?? 240,
              child: const ColorPickerPanel(),
            ),

          // Settings Panel
          if (uiState.showSettingsPanel)
            Positioned(
              top: uiState.panelPosition?.dy ?? 30,
              left: uiState.panelPosition?.dx ?? 240,
              child: const DrawingSettingsPanel(),
            ),
        ],
      ),
    );
  }
}
