import 'package:vivid_canvas/core/constants/app_assets.dart';
import 'package:vivid_canvas/core/constants/app_strings.dart';

import 'sub_tool_config.dart';
import 'tool_type.dart';

class ToolConfigurations {
  ToolConfigurations._();

  static const drawingTools = [
    SubToolConfig(iconPath: AppAssets.pen, label: AppStrings.pen),
    SubToolConfig(iconPath: AppAssets.marker, label: AppStrings.marker),
    SubToolConfig(
      iconPath: AppAssets.highlighter,
      label: AppStrings.highlighter,
    ),
    SubToolConfig(iconPath: AppAssets.eraser, label: AppStrings.eraser),
  ];

  static const shapeTools = [
    SubToolConfig(iconPath: AppAssets.circle, label: 'Circle'),
    SubToolConfig(iconPath: AppAssets.rectangle, label: 'Rectangle'),
    SubToolConfig(
      iconPath: AppAssets.roundedRectangle,
      label: 'Rounded Rectangle',
    ),
    SubToolConfig(iconPath: AppAssets.downTriangle, label: 'Triangle'),
    SubToolConfig(iconPath: AppAssets.triangle, label: 'Down Triangle'),
    SubToolConfig(iconPath: AppAssets.asterisk, label: 'Asterisk'),
    SubToolConfig(iconPath: AppAssets.heart, label: 'Heart'),
    SubToolConfig(iconPath: AppAssets.hexagonal, label: 'Hexagonal'),
  ];

  static const lineTools = [
    SubToolConfig(iconPath: AppAssets.nodes, label: 'Straight Line'),
    SubToolConfig(iconPath: AppAssets.line, label: 'Segmented Line'),
    SubToolConfig(iconPath: AppAssets.lineChart, label: 'Curved Line'),
  ];

  static const stickyNoteTools = [
    SubToolConfig(iconPath: AppAssets.stickyNotesBlue, label: 'Blue Note'),
    SubToolConfig(iconPath: AppAssets.stickyNotesYellow, label: 'Yellow Note'),
    SubToolConfig(iconPath: AppAssets.stickyNotesGreen, label: 'Green Note'),
    SubToolConfig(iconPath: AppAssets.stickyNotesOrange, label: 'Orange Note'),
    SubToolConfig(iconPath: AppAssets.stickyNotesPurple, label: 'Purple Note'),
    SubToolConfig(iconPath: AppAssets.stickyNotesRed, label: 'Red Note'),
  ];

  /// Get submenu items for a tool
  static List<SubToolConfig>? getSubmenuFor(ToolType tool) {
    switch (tool) {
      case ToolType.pencil:
        return drawingTools;
      case ToolType.shapes:
        return shapeTools;
      case ToolType.lines:
        return lineTools;
      case ToolType.stickyNotes:
        return stickyNoteTools;
      default:
        return null;
    }
  }
}
