import 'package:intl/intl.dart';

class AppFormat {
  static String date(String date) {
    DateTime dateTime = DateTime.parse(date);
    
    return DateFormat('dd MMM yyyy', 'id_ID').format(dateTime);
  }
}