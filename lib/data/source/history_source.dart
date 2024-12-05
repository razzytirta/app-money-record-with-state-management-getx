import 'package:app_money_record/config/api.dart';
import 'package:app_money_record/config/app_request.dart';
import 'package:app_money_record/config/session.dart';
import 'package:intl/intl.dart';

class HistorySource {
  static Future<Map?> analysis(String userId) async {
    try {
      String url = '${Api.history}/analysis.php';
      var response = await AppRequest.post(url, {
        'user_id': userId,
        'today': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      });

      // Check for a null response and return default values if necessary
      if (response == null) {
        print("Error: No response from the server.");
        return {
          'today': 0.0,
          'yesterday': 0.0,
          'week': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
          'month': {
            'income': 0.0,
            'outcome': 0.0,
          }
        };
      }

      return response;
    } catch (e) {
      // Log the error and return default values on exception
      print("Error during analysis request: $e");
      return {
        'today': 0.0,
        'yesterday': 0.0,
        'week': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        'month': {
          'income': 0.0,
          'outcome': 0.0,
        }
      };
    }
  }
}
