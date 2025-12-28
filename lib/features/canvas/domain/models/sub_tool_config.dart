import 'package:flutter/material.dart';

@immutable
class SubToolConfig {
  final String iconPath;
  final String label;
  final String? associatedData;

  const SubToolConfig({
    required this.iconPath,
    required this.label,
    this.associatedData,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubToolConfig &&
          iconPath == other.iconPath &&
          label == other.label &&
          associatedData == other.associatedData;

  @override
  int get hashCode =>
      iconPath.hashCode ^ label.hashCode ^ associatedData.hashCode;
}
