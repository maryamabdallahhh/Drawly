import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/tool_type.dart';
import '../../domain/models/sub_tool_config.dart';

/// Tool selection state
class ToolState {
  final ToolType selectedTool;
  final SubToolConfig? selectedSubTool;
  final Map<String, bool> hoverStates;

  const ToolState({
    required this.selectedTool,
    this.selectedSubTool,
    this.hoverStates = const {},
  });

  ToolState copyWith({
    ToolType? selectedTool,
    SubToolConfig? Function()? selectedSubTool,
    Map<String, bool>? hoverStates,
  }) {
    return ToolState(
      selectedTool: selectedTool ?? this.selectedTool,
      selectedSubTool: selectedSubTool != null
          ? selectedSubTool()
          : this.selectedSubTool,
      hoverStates: hoverStates ?? this.hoverStates,
    );
  }

  bool isToolSelected(ToolType tool) => selectedTool == tool;
  bool isSubToolSelected(SubToolConfig subTool) => selectedSubTool == subTool;
  bool isHovering(String key) => hoverStates[key] ?? false;
}

/// Tool state notifier
class ToolStateNotifier extends StateNotifier<ToolState> {
  ToolStateNotifier()
    : super(const ToolState(selectedTool: ToolType.selection));

  void selectTool(ToolType tool) {
    if (state.selectedTool == tool) {
      // Toggle off to selection
      state = const ToolState(selectedTool: ToolType.selection);
    } else {
      state = state.copyWith(selectedTool: tool, selectedSubTool: () => null);
    }
  }

  void selectSubTool(SubToolConfig subTool) {
    state = state.copyWith(selectedSubTool: () => subTool);
  }

  void setHover(String key, bool isHovering) {
    state = state.copyWith(
      hoverStates: {...state.hoverStates, key: isHovering},
    );
  }

  void clearSubTool() {
    state = state.copyWith(selectedSubTool: () => null);
  }

  void reset() {
    state = const ToolState(selectedTool: ToolType.selection);
  }
}

final toolStateProvider = StateNotifierProvider<ToolStateNotifier, ToolState>((
  ref,
) {
  return ToolStateNotifier();
});
