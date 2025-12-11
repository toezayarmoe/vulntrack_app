import 'package:flutter/material.dart';
import 'package:vulntrack_app/core/theme.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: appInputDecorationTheme,
        elevatedButtonTheme: btnTheme,
      ),
      home: Scaffold(body: LoginPage()),
      title: "Vulnerability Management System",
    ),
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400.0),
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(text: 'Vuln'),
                      TextSpan(
                        text: 'Track',
                        style: TextStyle(color: Color(0xFF3366FF)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text("Vulnerability Management System"),
                SizedBox(height: 32),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Username"),
                      SizedBox(height: 8.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Text("Password"),
                      SizedBox(height: 8.0),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Sign in"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
