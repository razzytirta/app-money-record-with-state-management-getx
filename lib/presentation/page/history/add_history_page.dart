import 'dart:convert';

import 'package:app_money_record/config/app_color.dart';
import 'package:app_money_record/config/app_format.dart';
import 'package:app_money_record/data/source/history_source.dart';
import 'package:app_money_record/presentation/controller/user_controller.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:d_input/d_input.dart';
import 'package:app_money_record/presentation/controller/history/add_history_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddHistoryPage extends StatelessWidget {
  AddHistoryPage({super.key});
  final historyC = Get.put(AddHistoryController());
  final userC = Get.put(UserController());
  final nameC = TextEditingController();
  final priceC = TextEditingController();

  addHistory() async {
    bool success = await HistorySource.add(
      userC.data.id!,
      historyC.date,
      historyC.type,
      jsonEncode(historyC.items),
      historyC.total.toString(),
    );
    if (success) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        Get.back(result: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft('Tambah Baru'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tanggal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Obx(() {
                return Text(historyC.date);
              }),
              DView.width(),
              ElevatedButton.icon(
                onPressed: () async {
                  var result = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2024, 01, 01),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  if (result != null) {
                    historyC.setDate(DateFormat('yyyy-MM-dd').format(result));
                  }
                },
                icon: const Icon(Icons.event),
                label: const Text('Pilih'),
              )
            ],
          ),
          DView.height(),
          const Text(
            'Tipe',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          DView.height(4),
          Obx(() {
            return DropdownButtonFormField(
              value: historyC.type,
              items: ['Pemasukan', 'Pengeluaran'].map(
                (e) {
                  return DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  );
                },
              ).toList(),
              onChanged: (value) {
                historyC.setType(value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            );
          }),
          DView.height(),
          DInput(
            controller: nameC,
            hint: 'Sumber Pemasukan/Pengeluaran',
            title: 'Sumber Pemasukan/Pengeluaran',
          ),
          DView.height(),
          DInput(
            controller: priceC,
            hint: '30000',
            title: 'Harga',
            inputType: TextInputType.number,
          ),
          DView.height(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
            ),
            onPressed: () {
              historyC.addItem({
                'name': nameC.text,
                'price': priceC.text,
              });

              nameC.clear();
              priceC.clear();
            },
            child: const Text(
              'Tambah ke Items',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          DView.height(),
          Center(
            child: Container(
              height: 5,
              width: 80,
              decoration: BoxDecoration(
                color: AppColor.background,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          DView.height(),
          const Text(
            'Items',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          DView.height(8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: GetBuilder<AddHistoryController>(builder: (_) {
              return Wrap(
                runSpacing: 0,
                spacing: 8,
                children: List.generate(_.items.length, (index) {
                  return Chip(
                    label: Text(_.items[index]['name']),
                    deleteIcon: const Icon(Icons.clear),
                    onDeleted: () => _.deleteItem(index),
                  );
                }),
              );
            }),
          ),
          DView.height(),
          Row(
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DView.width(),
              Obx(() {
                return Text(
                  AppFormat.currency(historyC.total.toString()),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                );
              }),
            ],
          ),
          DView.height(30),
          Material(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => addHistory(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'SUBMIT',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
