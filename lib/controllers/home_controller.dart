import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/config/environment.dart';
import 'package:vulntrack_app/screen/login_page.dart';
import 'package:vulntrack_app/services/networking.dart';
import 'package:vulntrack_app/utils/pref_helper.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var tokenStatus = "".obs;

  @override
  void onInit() {
    super.onInit();
    validateToken();
  }

  Future<void> validateToken() async {
    try {
      debugPrint("Got Here");
      isLoading.value = true;
      final req = NetworkHelper(Uri.parse(Env.profile));
      final res = await req.getDataWithAuth();
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        tokenStatus.value = resBody["message"];
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout({bool clearToken = true}) async {
    // You can use the same isLoading observable to show a loading state on logout
    isLoading.value = true;

    await Future.delayed(Duration(milliseconds: 500));

    if (clearToken) {
      await Preferences.remove("token");
    }

    // Navigate to Login
    Get.offAll(() => LoginPage());
  }
}
