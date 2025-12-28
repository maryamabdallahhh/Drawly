class IdGenerator {
  IdGenerator._();

  /// Generate a unique ID based on timestamp
  static String generate() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Generate a unique ID with prefix
  static String generateWithPrefix(String prefix) {
    return '${prefix}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
