import 'package:flutter/material.dart';

@immutable
class CanvasElement {
  final String id;
  final String type;
  final double x;
  final double y;
  final String color;
  final String? text;

  const CanvasElement({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.color,
    this.text,
  });

  factory CanvasElement.fromMap(String id, Map<String, dynamic> map) {
    return CanvasElement(
      id: id,
      type: map['type'] ?? 'sticky',
      x: (map['x'] ?? 0).toDouble(),
      y: (map['y'] ?? 0).toDouble(),
      color: map['color'] ?? 'yellow',
      text: map['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'x': x,
      'y': y,
      'color': color,
      if (text != null) 'text': text,
    };
  }

  CanvasElement copyWith({
    String? id,
    String? type,
    double? x,
    double? y,
    String? color,
    String? text,
  }) {
    return CanvasElement(
      id: id ?? this.id,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      color: color ?? this.color,
      text: text ?? this.text,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CanvasElement &&
          id == other.id &&
          type == other.type &&
          x == other.x &&
          y == other.y &&
          color == other.color &&
          text == other.text;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      x.hashCode ^
      y.hashCode ^
      color.hashCode ^
      text.hashCode;
}
