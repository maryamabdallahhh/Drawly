class CanvasElement {
  final String id;
  final String type; // 'sticky', 'line', 'shape'
  final double x;
  final double y;
  final String color;
  final String? text;

  CanvasElement({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.color,
    this.text,
  });

  // Convert Firestore data (Map) to our Flutter Object
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

  // Convert  Flutter Object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {'type': type, 'x': x, 'y': y, 'color': color, 'text': text};
  }
}
