import 'package:app_money_record/config/api.dart';
import 'package:app_money_record/config/app_request.dart';
import 'package:app_money_record/data/model/history.dart';
import 'package:intl/intl.dart';
import 'package:d_info/d_info.dart';

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

  static Future<bool> add(String userId, String date, String type,
      String details, String total) async {
    try {
      String url = '${Api.history}/add.php';
      var response = await AppRequest.post(url, {
        'user_id': userId,
        'date': date,
        'type': type,
        'details': details,
        'total': total,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      });

      if (response == null || response is! Map) {
        print('Invalid response from server: $response');
        DInfo.dialogError('No response from server. Please try again.');
        DInfo.closeDialog();
        return false;
      }

      if (response['success'] == true) {
        DInfo.dialogSuccess('History Added');
        DInfo.closeDialog();

        return true;
      } else {
        if (response['message'] == 'date') {
          DInfo.dialogError('History is already taken');
        } else {
          DInfo.dialogError('History addition failed. Please try again.');
        }
        DInfo.closeDialog();
        return false;
      }
    } catch (e) {
      print("Error during history request: $e");
      DInfo.dialogError(
          'An error occurred while registering. Please try again.');
      DInfo.closeDialog();
      return false;
    }
  }

  static Future<List<History>> incomeOutcome(String userId, String type) async {
    final String url = '${Api.history}/income_outcome.php';

    try {
      // Send POST request
      final response = await AppRequest.post(url, {
        'user_id': userId,
        'type': type,
      });

      // Handle null or invalid responses
      if (response == null) {
        print("Error: No response from the server.");
        return [];
      }

      // Check success and parse data
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((e) => History.fromJson(e)).toList();
      }

      // Log server error or unsuccessful status
      print("Error: ${response['message'] ?? 'Unknown server error.'}");
      return [];
    } catch (e, stackTrace) {
      // Log the exception with stack trace for debugging
      print("Exception in incomeOutcome: $e");
      print(stackTrace);
      return [];
    }
  }

  static Future<List<History>> incomeOutcomeSearch(
      String userId, String type, String date) async {
    final String url = '${Api.history}/income_outcome_search.php';

    try {
      // Send POST request
      final response = await AppRequest.post(url, {
        'user_id': userId,
        'type': type,
        'date': date,
      });

      // Handle null or invalid responses
      if (response == null) {
        print("Error: No response from the server.");
        return [];
      }

      // Check success and parse data
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((e) => History.fromJson(e)).toList();
      }

      // Log server error or unsuccessful status
      print("Error: ${response['message'] ?? 'Empty.'}");
      return [];
    } catch (e, stackTrace) {
      // Log the exception with stack trace for debugging
      print("Exception in incomeOutcome: $e");
      print(stackTrace);
      return [];
    }
  }
}
