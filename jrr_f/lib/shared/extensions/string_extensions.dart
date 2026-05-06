extension StringExtensions on String {
  /// Compares this string to [other] ignoring case.
  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();
}
