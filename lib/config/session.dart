import 'dart:convert';

import 'package:app_money_record/data/model/user.dart';
import 'package:app_money_record/presentation/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  static void _updateUserController(User user) {
    final userController = Get.put(UserController());
    userController.setData(user);
  }

  static Future<bool> save(User user) async {
    final pref = await _getPreferences();
    String stringUser = jsonEncode(user.toJson());
    bool success = await pref.setString('user', stringUser);
    if (success) {
      _updateUserController(user);
    }

    return success;
  }

  static Future<User?> getUser() async {
    final pref = await _getPreferences();
    String? stringUser = pref.getString('user');
    if (stringUser != null) {
      Map<String, dynamic> mapUser = jsonDecode(stringUser);
      User user = User.fromJson(mapUser);
      _updateUserController(user);
      return user;
    }
      _updateUserController(User());
      return null;
  }

  static Future<bool> delete() async {
    final pref = await _getPreferences();
    _updateUserController(User());
    return await pref.remove('user');
  }
}