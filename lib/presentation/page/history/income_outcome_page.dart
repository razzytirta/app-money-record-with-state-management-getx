import 'package:app_money_record/config/app_color.dart';
import 'package:app_money_record/config/app_format.dart';
import 'package:app_money_record/data/model/history.dart';
import 'package:app_money_record/data/source/history_source.dart';
import 'package:app_money_record/presentation/controller/history/income_outcome_controller.dart';
import 'package:app_money_record/presentation/controller/user_controller.dart';
import 'package:app_money_record/presentation/page/history/detail_history_page.dart';
import 'package:app_money_record/presentation/page/history/update_history_page.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:d_view/d_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IncomeOutcomePage extends StatefulWidget {
  const IncomeOutcomePage({super.key, required this.type});
  final String type;

  @override
  State<IncomeOutcomePage> createState() => _IncomeOutcomePageState();
}

class _IncomeOutcomePageState extends State<IncomeOutcomePage> {
  final inOutC = Get.put(IncomeOutcomeController());
  final userC = Get.put(UserController());
  final searchC = TextEditingController();

  refresh() {
    inOutC.getData(userC.data.id, widget.type);
  }

  menuOption(String value, History history) async {
    if (value == 'update') {
      Get.to(() => UpdateHistoryPage(
            date: history.date!,
            historyId: history.id!,
          ))?.then(
        (value) {
          if (value ?? false) {
            refresh();
          }
        },
      );
    } else if (value == 'delete') {
      var response = await DInfo.dialogConfirmation(
          context, 'Delete', 'Yakin untuk menghapus ?');
      if (response != null) {
        bool success = await HistorySource.delete(history.id!);
        if (success) {
          refresh();
        }
      }
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              Text(widget.type),
              Expanded(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.all(16),
                  child: TextField(
                    controller: searchC,
                    onTap: () async {
                      DateTime? result = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2024, 01, 01),
                          lastDate: DateTime(DateTime.now().year + 1),
                          initialDate: DateTime.now());

                      if (result != null) {
                        searchC.text = DateFormat('yyyy-MM-dd').format(result);
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColor.chart.withOpacity(0.5),
                      suffixIcon: IconButton(
                        onPressed: () {
                          inOutC.search(
                            userC.data.id,
                            widget.type,
                            searchC.text,
                          );
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                      hintText: '2024-01-01',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: GetBuilder<IncomeOutcomeController>(builder: (_) {
          if (_.loading) return DView.loadingCircle();
          if (_.data.isEmpty) return DView.empty('Empty');
          return RefreshIndicator(
            onRefresh: () async => refresh(),
            child: ListView.builder(
              itemCount: _.data.length,
              itemBuilder: (context, index) {
                History history = _.data[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.fromLTRB(
                    16,
                    index == 0 ? 16 : 8,
                    16,
                    index == _.data.length - 1 ? 16 : 8,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        () => DetailHistoryPage(
                          date: history.date,
                          userId: userC.data.id,
                          type: history.type,
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Row(
                      children: [
                        DView.width(),
                        Text(
                          AppFormat.date(history.date!),
                          style: const TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppFormat.currency(history.total!),
                            style: const TextStyle(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        PopupMenuButton<String>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text(
                                'Update',
                              ),
                              value: 'update',
                            ),
                            PopupMenuItem(
                              child: Text(
                                'Delete',
                              ),
                              value: 'delete',
                            ),
                          ],
                          onSelected: (value) => menuOption(value, history),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }));
  }
}
