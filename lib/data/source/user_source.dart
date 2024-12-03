import 'package:app_money_record/config/api.dart';
import 'package:app_money_record/config/app_request.dart';
import 'package:app_money_record/config/session.dart';
import 'package:app_money_record/data/model/user.dart';
import 'package:d_info/d_info.dart';

class UserSource {
  static Future<bool> login(String email, String password) async {
    try {
      String url = '${Api.user}/login.php';
      var response = await AppRequest.post(url, {
        'email': email, 
        'password': password
      });

      if (response == null) {
        print('Error: Response is null');
        return false;
      }

      if (response['success'] == true) {
        var mapUser = response['data'];
        Session.save(User.fromJson(mapUser));

        return true;
      } else {
          print("Login failed: ${response['message'] ?? 'Unknown error'}");
          return false;
      }
    } catch (e) {
      print("Error during login: $e");
      return false;
    }
  }

  static Future<bool> register(String name, String email, String password) async {
    try {
      String url = '${Api.user}/register.php';
      var response = await AppRequest.post(url, {
        'name': name, 
        'email': email, 
        'password': password,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      });

      if (response == null) {
        print('Error: Response is null');
        DInfo.dialogError('No response from server. Please try again.');
        DInfo.closeDialog();
        return false;
      }

      if (response['success'] == true) {
        DInfo.dialogSuccess('Register Successfully');
        DInfo.closeDialog();

        return true;
      } else {
          if (response['message'] == 'email') {
            DInfo.dialogError('Email is already taken');
          } else {
            DInfo.dialogError('Registration failed. Please try again.');
          }
          DInfo.closeDialog();
          return false;
      }
    } catch (e) {
      print("Error during register: $e");
      DInfo.dialogError('An error occurred while registering. Please try again.');
      DInfo.closeDialog();
      return false;
    }
  }
}