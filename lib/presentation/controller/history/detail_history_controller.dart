import 'dart:convert';

import 'package:app_money_record/data/model/history.dart';
import 'package:app_money_record/data/source/history_source.dart';
import 'package:get/get.dart';

class DetailHistoryController extends GetxController {
  final _data = History().obs;
  History get data => _data.value;

  getData(userId, date, type) async {
    History? history = await HistorySource.detail(userId, date, type);
    _data.value = history ?? History();
    update();
  }
}
