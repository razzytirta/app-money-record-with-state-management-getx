import 'package:app_money_record/config/app_asset.dart';
import 'package:app_money_record/config/app_color.dart';
import 'package:app_money_record/data/source/user_source.dart';
import 'package:app_money_record/presentation/page/auth/register_page.dart';
import 'package:app_money_record/presentation/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:d_view/d_view.dart';
import 'package:d_info/d_info.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      bool success = await UserSource.login(
        emailC.text, passwordC.text
      );

      setState(() {
        isLoading = false;  // Hide loading indicator
      });

      if (success) {
        DInfo.dialogSuccess('Login Successfully');
        DInfo.closeDialog(actionAfterClose: () {
          Get.off(() => const HomePage());
        });
      } else {
        DInfo.dialogError('Login Failed');
        DInfo.closeDialog();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DView.nothing(),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Image.asset(AppAsset.logo),
                        DView.height(40),
                        TextFormField(
                          controller: emailC,
                          validator: (value) => value == '' ? 'name is required' : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(color: Colors.white,),
                          decoration: InputDecoration(
                            fillColor: AppColor.primary.withOpacity(0.5),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Email",
                            hintStyle: const TextStyle(color: Colors.white,),
                            isDense: true,
                            contentPadding:const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          ),
                        ),
                        DView.height(),
                        TextFormField(
                          controller: passwordC,
                          validator: (value) => value == '' ? 'password is required' : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white,),
                          decoration: InputDecoration(
                            fillColor: AppColor.primary.withOpacity(0.5),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Password",
                            hintStyle: const TextStyle(color: Colors.white,),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          ),
                        ),
                        DView.height(30),
                        isLoading ? const CircularProgressIndicator() :
                        Material(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            onTap: () => login(),
                            borderRadius: BorderRadius.circular(30),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              child: Text("LOGIN", 
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const RegisterPage());
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Belum punya akun? ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text('Register', 
                          style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },)
    );
  }
}