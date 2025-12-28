import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';

enum ToolType {
  selection(AppAssets.selection, AppStrings.selection, false),
  pencil(AppAssets.pencil, AppStrings.draw, true),
  shapes(AppAssets.shapesIcon, AppStrings.shapes, true),
  lines(AppAssets.linesIcon, AppStrings.lines, true),
  stickyNotes(AppAssets.stickyNotesIcon, AppStrings.stickyNotes, true),
  textBox(AppAssets.textBox, AppStrings.text, false),
  table(AppAssets.table, AppStrings.table, false);

  final String iconPath;
  final String label;
  final bool hasSubmenu;

  const ToolType(this.iconPath, this.label, this.hasSubmenu);
}
