import 'dart:convert';

import 'package:app_money_record/config/app_color.dart';
import 'package:app_money_record/config/app_format.dart';
import 'package:app_money_record/presentation/controller/history/detail_history_controller.dart';
import 'package:app_money_record/presentation/controller/user_controller.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailHistoryPage extends StatefulWidget {
  const DetailHistoryPage({super.key, this.userId, this.date});
  final String? userId;
  final String? date;

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  final detailHistoryC = Get.put(DetailHistoryController());

  @override
  void initState() {
    detailHistoryC.getData(
      widget.userId,
      widget.date,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Obx(() {
          if (detailHistoryC.data.date == null) return DView.nothing();
          return Row(
            children: [
              Expanded(
                child: Text(
                  AppFormat.date(detailHistoryC.data.date!),
                ),
              ),
              detailHistoryC.data.type == 'Pemasukan'
                  ? Icon(
                      Icons.south_west,
                      color: Colors.green[300],
                    )
                  : Icon(
                      Icons.north_east,
                      color: Colors.red[300],
                    ),
              DView.width(),
            ],
          );
        }),
      ),
      body: GetBuilder<DetailHistoryController>(builder: (_) {
        if (_.data.date == null) return DView.nothing();
        List details = jsonDecode(_.data.details!);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "Total",
                style: TextStyle(
                  color: AppColor.primary.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Text(
                AppFormat.currency(_.data.total!),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: AppColor.primary,
                    ),
              ),
            ),
            Center(
              child: Container(
                height: 5,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColor.background,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            DView.height(20),
            Expanded(
              child: ListView.separated(
                itemCount: details.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  Map item = details[index];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}.',
                          style: const TextStyle(fontSize: 20),
                        ),
                        DView.width(8),
                        Expanded(
                          child: Text(
                            item['name'],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        Text(
                          AppFormat.currency(item['price']),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
