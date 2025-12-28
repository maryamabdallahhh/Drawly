enum DrawingToolType {
  pen,
  marker,
  highlighter,
  eraser;

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
    }
  }

  bool get isEraser => this == DrawingToolType.eraser;
}
