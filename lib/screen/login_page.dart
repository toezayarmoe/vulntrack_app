import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                  Material(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Vuln',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Track',
                            style: TextStyle(color: Color(0xFF3366FF)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("Vulnerability Management System"),
                  SizedBox(height: 32),
                  Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Username"),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: controller.usernameController,
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
                          controller: controller.passwordController,
                          obscureText: true,
                          decoration: InputDecoration(),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => controller.login(),
                        ),
                        SizedBox(height: 30.0),
                        Obx(
                          () => controller.errorMessage.value != null
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 15.0),
                                  child: Text(controller.errorMessage.value!),
                                )
                              : const SizedBox.shrink(),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Obx(
                            () => ElevatedButton(
                              // Disable button if loading
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.login,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      "Sign in",
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ),
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
      ),
    );
  }
}
