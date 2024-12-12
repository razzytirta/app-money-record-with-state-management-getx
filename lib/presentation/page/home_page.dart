import 'package:app_money_record/config/app_asset.dart';
import 'package:app_money_record/config/app_color.dart';
import 'package:app_money_record/config/app_format.dart';
import 'package:app_money_record/config/session.dart';
import 'package:app_money_record/presentation/controller/home_controller.dart';
import 'package:app_money_record/presentation/controller/user_controller.dart';
import 'package:app_money_record/presentation/page/auth/login_page.dart';
import 'package:app_money_record/presentation/page/history/add_history_page.dart';
import 'package:app_money_record/presentation/page/history/detail_history_page.dart';
import 'package:app_money_record/presentation/page/history/history_page.dart';
import 'package:app_money_record/presentation/page/history/income_outcome_page.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:d_chart/d_chart.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userC = Get.put(UserController());
  final homeC = Get.put(HomeController());
  @override
  void initState() {
    homeC.getAnalysis(userC.data.id!);
    super.initState();
  }

  TimeData maxTimeData = TimeData(domain: DateTime(2024, 1), measure: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: drawer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: Row(
                children: [
                  Image.asset(AppAsset.profile),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hi,',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Obx(() {
                          return Text(
                            userC.data.name!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          );
                        })
                      ],
                    ),
                  ),
                  Builder(builder: (context) {
                    return Material(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColor.chart,
                      child: InkWell(
                        onTap: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Icon(
                            Icons.menu,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  homeC.getAnalysis(userC.data.id!);
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  children: [
                    Text(
                      "Pengeluaran Hari Ini",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    DView.height(),
                    cardToday(context),
                    DView.height(30),
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
                    DView.height(30),
                    Text(
                      "Pengeluaran Minggu Ini",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    DView.height(),
                    weekly(),
                    DView.height(30),
                    Text(
                      "Perbandingan Bulan Ini",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    DView.height(),
                    monthly(context)
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Drawer drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            margin: const EdgeInsets.only(bottom: 0),
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(AppAsset.profile),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return Text(
                              userC.data.name!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            );
                          }),
                          Obx(() {
                            return Text(
                              userC.data.email!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                Material(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () {
                      Session.delete();
                      Get.off(
                        () => const LoginPage(),
                      );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Get.to(() => AddHistoryPage())?.then(
                (value) {
                  if (value ?? false) {
                    homeC.getAnalysis(userC.data.id!);
                  }
                },
              );
            },
            leading: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
            horizontalTitleGap: 8.0, // Atur jarak antara ikon dan judul
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Atur padding konten
            title: const Text('Tambah baru'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {
              Get.to(() => const IncomeOutcomePage(
                    type: 'Pemasukan',
                  ));
            },
            leading: const Icon(
              Icons.south_west,
              color: Colors.green,
            ),
            horizontalTitleGap: 8.0, // Atur jarak antara ikon dan judul
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Atur padding konten
            title: const Text('Pemasukan'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {
              Get.to(() => const IncomeOutcomePage(
                    type: 'Pengeluaran',
                  ));
            },
            leading: const Icon(
              Icons.north_east,
              color: Colors.red,
            ),
            horizontalTitleGap: 8.0, // Atur jarak antara ikon dan judul
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Atur padding konten
            title: const Text('Pengeluaran'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {
              Get.to(() => const HistoryPage());
            },
            leading: const Icon(
              Icons.history,
              color: Colors.grey,
            ),
            horizontalTitleGap: 8.0, // Atur jarak antara ikon dan judul
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Atur padding konten
            title: const Text('Riwayat'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  Row monthly(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
          child: Stack(
            children: [
              Obx(() {
                return DChartPieO(
                  data: [
                    OrdinalData(
                      domain: 'Income',
                      measure: homeC.monthIncome,
                      color: AppColor.primary,
                    ),
                    OrdinalData(
                      domain: 'Outcome',
                      measure: homeC.monthOutcome,
                      color: AppColor.chart,
                    ),
                    OrdinalData(
                      domain: 'Nol',
                      measure:
                          (homeC.monthIncome == 0 && homeC.monthOutcome == 0)
                              ? 1
                              : 0,
                      color: (homeC.monthIncome == 0 && homeC.monthOutcome == 0)
                          ? AppColor.background.withOpacity(0.5)
                          : const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                  configRenderPie: const ConfigRenderPie(
                    arcWidth: 10,
                    strokeWidthPx: 0,
                  ),
                );
              }),
              Center(
                child: Obx(() {
                  return Text(
                    '${homeC.percentIncome}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: Colors.black87,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.primary,
                ),
                DView.width(8),
                const Text('Pemasukan'),
              ],
            ),
            DView.height(8),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.chart,
                ),
                DView.width(8),
                const Text('Pengeluaran'),
              ],
            ),
            DView.height(20),
            Obx(() {
              return Text(homeC.monthPercent);
            }),
            DView.height(10),
            const Text('Atau setara:'),
            Obx(() {
              return Text(
                AppFormat.currency(homeC.differentMonth.toString()),
                style: const TextStyle(
                  color: AppColor.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            })
          ],
        ),
      ],
    );
  }

  AspectRatio weekly() {
    // List<OrdinalData> series1 = [
    //   OrdinalData(domain: 'Feb', measure: 43),
    //   OrdinalData(domain: 'Mar', measure: 40),
    //   OrdinalData(domain: 'Apr', measure: 67),
    //   OrdinalData(domain: 'Mei', measure: 28),
    // ];
    // List<OrdinalData> series2 = [
    //   OrdinalData(domain: 'Jan', measure: 30),
    //   OrdinalData(domain: 'Feb', measure: 60),
    //   OrdinalData(domain: 'Mar', measure: 40),
    //   OrdinalData(domain: 'Apr', measure: 50),
    //   OrdinalData(domain: 'Mei', measure: 30),
    // ];
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(() {
        return DChartBarO(
          layoutMargin: LayoutMargin(40, 10, 10, 10),
          configRenderBar: const ConfigRenderBar(
            barGroupingType: BarGroupingType.stacked,
            stackedBarPaddingPx: 4,
            maxBarWidthPx: 20,
          ),
          domainAxis: DomainAxis(
            showLine: true,
            lineStyle: LineStyle(color: Colors.grey.shade200),
            tickLength: 0,
            gapAxisToLabel: 12,
            labelStyle: const LabelStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
          measureAxis: const MeasureAxis(
            gapAxisToLabel: 8,
            numericTickProvider: NumericTickProvider(
              desiredMinTickCount: 5,
              desiredMaxTickCount: 10,
            ),
            tickLength: 0,
            labelStyle: LabelStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
          groupList: [
            OrdinalGroup(
              id: '1',
              data: List.generate(
                7,
                (index) {
                  return OrdinalData(
                      domain: homeC.weekText()[index],
                      measure: homeC.week[index]);
                },
              ),
              color: AppColor.primary,
            ),
          ],
        );
      }),
    );
  }

  Material cardToday(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 5,
      color: AppColor.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Obx(() {
              return Text(
                AppFormat.currency(homeC.today.toString()),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.secondary,
                    ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Obx(() {
              return Text(
                homeC.todayPercent,
                style: const TextStyle(
                    color: Color.fromARGB(255, 201, 191, 241), fontSize: 16),
              );
            }),
          ),
          GestureDetector(
            onTap: () => Get.to(() => DetailHistoryPage(
                  date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  userId: userC.data.id!,
                )),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Selengkapnya",
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 16,
                    ),
                  ),
                  const Icon(Icons.navigate_next),
                  DView.height()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
