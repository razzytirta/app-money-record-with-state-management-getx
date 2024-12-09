import 'package:intl/intl.dart';

class AppFormat {
  static String date(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd MMM yyyy', 'id_ID')
          .format(dateTime); // Format in Indonesian locale
    } catch (e) {
      print('Error formatting date: $e');
      return date; // Fallback to the original date string
    }
  }

  static String currency(String number) {
    return NumberFormat.currency(
      decimalDigits: 2,
      locale: 'id_ID',
      symbol: 'Rp ',
    ).format(double.parse(number));
  }
}
