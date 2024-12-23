import 'package:app_money_record/config/app_color.dart';
import 'package:app_money_record/config/session.dart';
import 'package:app_money_record/data/model/user.dart';
import 'package:app_money_record/presentation/page/auth/login_page.dart';
import 'package:app_money_record/presentation/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    String systemLocale = await findSystemLocale();
    print('System Locale: $systemLocale');
    await initializeDateFormatting('id_ID', null);
  } catch (e) {
    print('Error initializing date formatting: $e');
  }

  runApp(const MyApp());
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
              primary: AppColor.primary, secondary: AppColor.secondary),
          appBarTheme: const AppBarTheme(
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.white)),
      home: FutureBuilder(
          future: Session.getUser(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.data != null && snapshot.data!.id != null) {
              return const HomePage();
            }

            return const LoginPage();
          }),
    );
  }
}
