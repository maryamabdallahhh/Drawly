import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UiState {
  final bool showColorPicker;
  final bool showSettingsPanel;
  final Offset? panelPosition;

  const UiState({
    this.showColorPicker = false, 
    this.showSettingsPanel = false,
    this.panelPosition,
  });

  UiState copyWith({
    bool? showColorPicker, 
    bool? showSettingsPanel,
    Offset? panelPosition,
  }) {
    return UiState(
      showColorPicker: showColorPicker ?? this.showColorPicker,
      showSettingsPanel: showSettingsPanel ?? this.showSettingsPanel,
      panelPosition: panelPosition ?? this.panelPosition,
    );
  }
}

class UiStateNotifier extends StateNotifier<UiState> {
  UiStateNotifier() : super(const UiState());

  void toggleColorPicker([Offset? position]) {
    state = state.copyWith(
      showColorPicker: !state.showColorPicker,
      showSettingsPanel: false,
      panelPosition: position, // Only update position when passed
    );
  }

  void toggleSettingsPanel([Offset? position]) {
    state = state.copyWith(
      showSettingsPanel: !state.showSettingsPanel,
      showColorPicker: false,
      panelPosition: position, // Only update position when passed
    );
  }

  void closeAllPanels() {
    state = const UiState();
  }

  void closeColorPicker() {
    state = state.copyWith(showColorPicker: false);
  }

  void closeSettingsPanel() {
    state = state.copyWith(showSettingsPanel: false);
  }
}

final uiStateProvider = StateNotifierProvider<UiStateNotifier, UiState>((ref) {
  return UiStateNotifier();
});
