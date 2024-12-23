import 'package:app_money_record/data/source/history_source.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final _today = 0.0.obs;
  double get today => _today.value;

  final _todayPercent = ''.obs;
  String get todayPercent => _todayPercent.value;

  final _week = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  List<double> get week => _week.value;

  List<String> get days => ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  List<String> weekText() {
    DateTime today = DateTime.now();
    return [
      days[today.subtract(Duration(days: 6)).weekday - 1],
      days[today.subtract(Duration(days: 5)).weekday - 1],
      days[today.subtract(Duration(days: 4)).weekday - 1],
      days[today.subtract(Duration(days: 3)).weekday - 1],
      days[today.subtract(Duration(days: 2)).weekday - 1],
      days[today.subtract(Duration(days: 1)).weekday - 1],
      days[today.weekday - 1],
    ];
  }

  // final _month = {'income': 0.0, 'outcome': 0.0}.obs;
  // Map get month => _month.value;

  final _monthIncome = 0.0.obs;
  double get monthIncome => _monthIncome.value;

  final _monthOutcome = 0.0.obs;
  double get monthOutcome => _monthOutcome.value;

  final _percentIncome = '0'.obs;
  String get percentIncome => _percentIncome.value;

  final _monthPercent = ''.obs;
  String get monthPercent => _monthPercent.value;

  final _differentMonth = 0.0.obs;
  double get differentMonth => _differentMonth.value;

  getAnalysis(String userId) async {
    Map? data = await HistorySource.analysis(userId);
    if (data == null) return; // Add null check for data.

    _today.value = data['today'].toDouble();
    double yesterday = data['yesterday'].toDouble();
    double different = (today - yesterday).abs();
    bool isSame = today.isEqual(yesterday); // Use '==' for comparison
    bool isPlus = today.isGreaterThan(yesterday); // Use '>' for comparison
    double dividerToday = (today + yesterday) == 0 ? 1 : (today + yesterday);
    double percent = (different / dividerToday) * 100;
    _todayPercent.value = isSame
        ? '100% sama dengan kemaren'
        : isPlus
            ? '+${percent.toStringAsFixed(1)}% dibanding kemarin'
            : '-${percent.toStringAsFixed(1)}% dibanding kemarin';

    _week.value = List.castFrom(data['week'].map((e) => e.toDouble()).toList());

    _monthIncome.value = data['month']['income'].toDouble();
    _monthOutcome.value = data['month']['outcome'].toDouble();
    _differentMonth.value = (monthIncome - monthOutcome).abs();
    bool isSameMonth =
        monthIncome.isEqual(monthOutcome); // Use '==' for comparison
    bool isPlusMonth =
        monthIncome.isGreaterThan(monthOutcome); // Use '>' for comparison
    double dividerMonth =
        (monthIncome + monthOutcome) == 0 ? 1 : (monthIncome + monthOutcome);
    double percentMonth = (differentMonth / dividerMonth) * 100;
    _percentIncome.value = percentMonth.toStringAsFixed(1);
    _monthPercent.value = isSameMonth
        ? 'Pemasukan\n100% sama\ndengan Pengeluaran'
        : isPlusMonth
            ? 'Pemasukan\nlebih besar $percentIncome%\n Pengeluaran'
            : 'Pemasukan\nlebih kecil $percentIncome%\n Pengeluaran';
  }
}
