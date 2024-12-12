import 'package:app_money_record/data/model/history.dart';
import 'package:app_money_record/data/source/history_source.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _data = <History>[].obs;
  List<History> get data => _data.value;

  getData(userId) async {
    _loading.value = true;
    update();

    _data.value = await HistorySource.history(userId);
    update();

    Future.delayed(Duration(microseconds: 1500), () {
      _loading.value = false;
      update();
    });
  }

  search(userId, date) async {
    _loading.value = true;
    update();

    _data.value = await HistorySource.historySearch(userId, date);
    update();

    Future.delayed(Duration(microseconds: 1500), () {
      _loading.value = false;
      update();
    });
  }
}
