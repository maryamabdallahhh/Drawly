// core/constants/tool_constants.dart

import 'package:flutter/material.dart';

/// Constants for tool item styling and animations
class ToolItemConstants {
  ToolItemConstants._();

  // Colors
  static const Color selectedPurple = Color(0xFFF2EAFF);
  static const Color selectedGrey = Color(0xffE1E4E7);
  static const Color hoverGrey = Color(0xffF2F3F5);
  static const Color iconPurple = Color(0xff612DAE);
  static const Color tooltipBackground = Color(0xFF424242);

  // Sizes
  static const double itemSize = 24.0;
  static const double itemPadding = 8.0;
  static const double itemMargin = 4.0;
  static const double toolbarWidth = 60.0;
  static const double borderRadius = 8.0;
  static const double tooltipOffset = 50.0;

  // Animation
  static const Duration animationDuration = Duration(milliseconds: 200);
}

/// Enum for main tool types to avoid magic strings
enum ToolType {
  selection('assets/icons/selection.png', 'Select'),
  pencil('assets/icons/pencil.png', 'Draw'),
  shapes('assets/icons/shapes.png', 'Shapes'),
  lines('assets/icons/arrow-right.png', 'Lines'),
  stickyNotes('assets/icons/sticky-notes.png', 'Sticky Notes'),
  textBox('assets/icons/text-box.png', 'Text'),
  table('assets/icons/table.png', 'Table');

  final String assetPath;
  final String label;

  const ToolType(this.assetPath, this.label);

  /// Check if this tool has a submenu
  bool get hasSubmenu =>
      this == shapes || this == pencil || this == lines || this == stickyNotes;
}

/// Enum for tooltip positioning
enum TooltipPosition { left, right }

/// Configuration for sub-tools (shapes, drawing tools, etc.)
class SubToolConfig {
  final String assetPath;
  final String label;

  const SubToolConfig(this.assetPath, this.label);
}

/// Submenu configurations for each tool type
class ToolSubmenuConfig {
  ToolSubmenuConfig._();

  static const Map<ToolType, List<SubToolConfig>> submenus = {
    ToolType.shapes: [
      SubToolConfig('assets/icons/circle.png', 'Circle'),
      SubToolConfig('assets/icons/rectangle.png', 'Rectangle'),
      SubToolConfig('assets/icons/rounded-rectangle.png', 'Rounded Rectangle'),
      SubToolConfig('assets/icons/down_triangle.png', 'Triangle'),
      SubToolConfig('assets/icons/triangle.png', 'Down Triangle'),
      SubToolConfig('assets/icons/asterisk.png', 'Asterisk'),
      SubToolConfig('assets/icons/heart.png', 'Heart'),
      SubToolConfig('assets/icons/hexagonal.png', 'Hexagonal'),
    ],
    ToolType.pencil: [
      SubToolConfig('assets/icons/pen.png', 'Pen'),
      SubToolConfig('assets/icons/marker.png', 'Marker'),
      SubToolConfig('assets/icons/highlighter.png', 'Highlighter'),
      SubToolConfig('assets/icons/eraser.png', 'Eraser'),
    ],
    ToolType.lines: [
      SubToolConfig('assets/icons/nodes.png', 'Straight Line'),
      SubToolConfig('assets/icons/line.png', 'Segmented Line'),
      SubToolConfig('assets/icons/line-chart.png', 'Curved Line'),
    ],
    ToolType.stickyNotes: [
      SubToolConfig('assets/icons/sticky-notes-blue.png', 'Blue Note'),
      SubToolConfig('assets/icons/sticky-notes-yellow.png', 'Yellow Note'),
      SubToolConfig('assets/icons/sticky-notes-green.png', 'Green Note'),
      SubToolConfig('assets/icons/sticky-notes-orange.png', 'Orange Note'),
      SubToolConfig('assets/icons/sticky-notes-purple.png', 'Purple Note'),
      SubToolConfig('assets/icons/sticky-notes-red.png', 'Red Note'),
    ],
  };

  /// Get submenu items for a given tool
  static List<SubToolConfig>? getSubmenuFor(String toolPath) {
    final toolType = ToolType.values.firstWhere(
      (t) => t.assetPath == toolPath,
      orElse: () => ToolType.selection,
    );
    return submenus[toolType];
  }
}
