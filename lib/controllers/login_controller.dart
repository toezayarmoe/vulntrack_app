import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:vulntrack_app/config/environment.dart';
import 'package:vulntrack_app/screen/login_page.dart';
import 'package:vulntrack_app/services/networking.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final String _loginAPIUrl = "${Env.baseURL}/login";

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final username = usernameController.text;
      final password = passwordController.text;
      debugPrint(username);
      debugPrint(password);
      final helper = NetworkHelper(Uri.parse(_loginAPIUrl));
      final response = await helper.postData({
        'username': username,
        'password': password,
      });
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        debugPrint('Login Success : ${responseBody['token']}');
        Get.offAll(() => const HomeScreen());
      } else if (response.statusCode == 401) {
        final errorData = jsonDecode(response.body);
        errorMessage.value =
            errorData['message'] ?? 'Invalid username or password.';
      } else {
        errorMessage.value =
            'Login failed. Status code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Login failed. Status Code $e ';
    } finally {
      isLoading.value = false;
    }
  }
}
