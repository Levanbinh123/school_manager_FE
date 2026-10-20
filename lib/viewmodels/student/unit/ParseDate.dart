

DateTime? _parseDate(String value) {
  final parts = value.split('/');

  if (parts.length != 3) {
    return null;
  }

  try {
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    return DateTime(year, month, day);
  } catch (_) {
    return null;
  }
}