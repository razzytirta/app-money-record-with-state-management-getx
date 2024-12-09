import 'package:app_money_record/data/model/history.dart';
import 'package:app_money_record/data/source/history_source.dart';
import 'package:get/get.dart';

class IncomeOutcomeController extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _data = <History>[].obs;
  List<History> get data => _data.value;

  getData(userId, type) async {
    _loading.value = true;
    update();

    _data.value = await HistorySource.incomeOutcome(userId, type);
    update();

    Future.delayed(Duration(microseconds: 1500), () {
      _loading.value = false;
      update();
    });
  }

  search(userId, type, date) async {
    _loading.value = true;
    update();

    _data.value = await HistorySource.incomeOutcomeSearch(userId, type, date);
    update();

    Future.delayed(Duration(microseconds: 1500), () {
      _loading.value = false;
      update();
    });
  }
}
