import 'package:app_money_record/data/model/user.dart';
import 'package:get/get.dart';

class UserController  extends GetxController {
  final _data = User().obs;
  User get data => _data.value;

  setData(n) => _data.value = n;
}