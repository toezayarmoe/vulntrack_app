import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:vulntrack_app/core/theme.dart';
import 'package:vulntrack_app/screen/login_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        inputDecorationTheme: appInputDecorationTheme,
        elevatedButtonTheme: btnTheme,
      ),
      home: LoginPage(),
      title: "Vulnerability Management System",
    ),
  );
}
