import 'package:app_money_record/config/app_color.dart';
import 'package:app_money_record/config/session.dart';
import 'package:app_money_record/data/model/user.dart';
import 'package:app_money_record/presentation/page/auth/login_page.dart';
import 'package:app_money_record/presentation/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_file.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('id_ID', '').then((_) {
      runApp(const MyApp());
    });
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const MyApp());
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: AppColor.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColor.primary,
          secondary: AppColor.secondary
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white
        )
      ),
      home: FutureBuilder(
        future: Session.getUser(), 
        builder: (context,AsyncSnapshot<User?> snapshot) {
          if (snapshot.data != null && snapshot.data!.id != null) {
            return HomePage();
          }

          return LoginPage();
        }),
    );
  }
}