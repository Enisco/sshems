extension StringsExtension on String {
  String toWattsString() {
    double value = double.tryParse(this) ?? 0.0;
    String formattedValue =
        value.round().toString(); // Round to nearest integer
    String numberWithCommas = formattedValue.replaceAllMapped(
        RegExp(
            r'(\d{1,3})(?=(\d{3})+(?!\d))'), // Regex to add commas every 3 digits
        (Match match) => '${match[1]},');
    return '$numberWithCommas W';
  }
}
