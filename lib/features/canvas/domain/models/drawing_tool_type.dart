enum DrawingToolType {
  pen,
  marker,
  highlighter,
  eraser,
  circle,
  rectangle,
  roundedRectangle,
  triangle,
  downTriangle,
  asterisk,
  heart,
  hexagonal;

  String get label {
    switch (this) {
      case DrawingToolType.pen:
        return 'Pen';
      case DrawingToolType.marker:
        return 'Marker';
      case DrawingToolType.highlighter:
        return 'Highlighter';
      case DrawingToolType.eraser:
        return 'Eraser';
      case DrawingToolType.circle:
        return 'Circle';
      case DrawingToolType.rectangle:
        return 'Rectangle';
      case DrawingToolType.roundedRectangle:
        return 'Rounded Rectangle';
      case DrawingToolType.triangle:
        return 'Triangle';
      case DrawingToolType.downTriangle:
        return 'Down Triangle';
      case DrawingToolType.asterisk:
        return 'Asterisk';
      case DrawingToolType.heart:
        return 'Heart';
      case DrawingToolType.hexagonal:
        return 'Hexagonal';
    }
  }

  bool get isEraser => this == DrawingToolType.eraser;
  bool get isShape => index >= DrawingToolType.circle.index;
}
