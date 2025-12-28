import 'package:flutter_riverpod/flutter_riverpod.dart';

class UiState {
  final bool showColorPicker;
  final bool showSettingsPanel;

  const UiState({this.showColorPicker = false, this.showSettingsPanel = false});

  UiState copyWith({bool? showColorPicker, bool? showSettingsPanel}) {
    return UiState(
      showColorPicker: showColorPicker ?? this.showColorPicker,
      showSettingsPanel: showSettingsPanel ?? this.showSettingsPanel,
    );
  }
}

class UiStateNotifier extends StateNotifier<UiState> {
  UiStateNotifier() : super(const UiState());

  void toggleColorPicker() {
    state = state.copyWith(
      showColorPicker: !state.showColorPicker,
      showSettingsPanel: false,
    );
  }

  void toggleSettingsPanel() {
    state = state.copyWith(
      showSettingsPanel: !state.showSettingsPanel,
      showColorPicker: false,
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
