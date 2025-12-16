import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VulnTrack Dashboard')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                if (controller.isLoading.value) {
                  return CircularProgressIndicator();
                } else {
                  return Text(controller.tokenStatus.value);
                }
              }),
              SizedBox(height: 40),
              Obx(
                () => TextButton(
                  onPressed: controller.isLoading.value
                      ? null // Disable button while validating or logging out
                      : () => controller.logout(
                          clearToken: true,
                        ), // Force clear on manual logout
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("Logout"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
