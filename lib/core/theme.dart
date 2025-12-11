import 'package:flutter/material.dart';

final String url = "http://localhost:5000";

final InputDecorationTheme appInputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: Colors.grey.shade300),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: Colors.grey.shade300),
  ),
  focusedBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Color(0xFF3366FF), width: 2.0),
  ),
  errorBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),
  focusedErrorBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),
  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
);

final ElevatedButtonThemeData btnTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF3366FF),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
);
