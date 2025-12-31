import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/config/environment.dart';
import 'package:vulntrack_app/models/report_model.dart';
import 'package:vulntrack_app/services/networking.dart';

class ReportsController extends GetxController {
  var isLoading = false.obs;
  var reports = <ReportModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      isLoading.value = true;
      final req = NetworkHelper(Uri.parse(Env.reports));
      final res = await req.getDataWithAuth();

      if (res.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(res.body);
        reports.value = jsonList.map((e) => ReportModel.fromJson(e)).toList();
      } else {
        debugPrint("Error fetching reports: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception fetching reports: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
