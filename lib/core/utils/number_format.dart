/// Rounds [value] to the nearest whole number and formats it with
/// thousand-separating commas (e.g. `2471.0` -> `'2,471'`), matching the
/// design's `.toLocaleString()` formatting for large calorie/water figures.
String groupedInt(num value) {
  final digits = value.round().abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return value < 0 ? '-$buffer' : buffer.toString();
}
