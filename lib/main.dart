import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/controllers/home_controller.dart';
import 'package:vulntrack_app/controllers/login_controller.dart';
import 'package:vulntrack_app/core/theme.dart';
import 'package:vulntrack_app/screen/home_page.dart';
import 'package:vulntrack_app/screen/login_page.dart';
import 'package:vulntrack_app/utils/pref_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  String? token = Preferences.getString("token");
  debugPrint(token);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: true,
      theme: ThemeData(
        inputDecorationTheme: appInputDecorationTheme,
        elevatedButtonTheme: btnTheme,
      ),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController(), fenix: true);

        Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
      }),
      initialRoute: token != null ? '/home' : '/login',
      getPages: [
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
      ],
      title: "Vulnerability Management System",
    ),
  );
}
