import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:vulntrack_app/core/theme.dart';
import 'package:vulntrack_app/screen/home_page.dart';
import 'package:vulntrack_app/screen/login_page.dart';
import 'package:vulntrack_app/utils/pref_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = Preferences.getString("token");
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        inputDecorationTheme: appInputDecorationTheme,
        elevatedButtonTheme: btnTheme,
      ),
      home: token != null ? HomeScreen() : LoginPage(),
      title: "Vulnerability Management System",
    ),
  );
}
