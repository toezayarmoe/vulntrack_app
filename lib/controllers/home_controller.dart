import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/config/environment.dart';
import 'package:vulntrack_app/models/env_severity.dart';
import 'package:vulntrack_app/services/networking.dart';
import 'package:vulntrack_app/utils/pref_helper.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var isLoadingEnv = false.obs;
  var critical = 0.obs;
  var high = 0.obs;
  var medium = 0.obs;
  var low = 0.obs;
  var info = 0.obs;
  final Rxn<EnvSeverity> envdata = Rxn<EnvSeverity>();

  @override
  void onInit() {
    super.onInit();
    fetchGlobalSummary();
    fetchSummaryPerEnv();
  }

  Future<void> fetchGlobalSummary() async {
    try {
      isLoading.value = true;
      final req = NetworkHelper(Uri.parse(Env.globalsummary));
      final res = await req.getDataWithAuth();
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        critical.value = resBody["critical"];
        high.value = resBody["high"];
        medium.value = resBody["medium"];
        low.value = resBody["low"];
        info.value = resBody["info"];
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSummaryPerEnv() async {
    try {
      debugPrint("Fetching Summary Per Environment");
      isLoadingEnv.value = true;
      final req = NetworkHelper(Uri.parse(Env.summaryperenv));
      final res = await req.getDataWithAuth();
      if (res.statusCode == 200) {
        Map<String, dynamic> userMap = jsonDecode(res.body);
        EnvSeverity response = EnvSeverity.fromJson(userMap);
        envdata.value = response;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingEnv.value = false;
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
    Get.offAllNamed('/login');
  }
}
