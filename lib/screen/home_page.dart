import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/controllers/home_controller.dart';
import 'package:vulntrack_app/models/severity_model.dart';
import 'package:vulntrack_app/widget/piechart_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("token");
    return Scaffold(
      appBar: AppBar(
        title: const Text('VulnTrack Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.logout(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive logic: 3 columns if width > 600, else 1
          int crossAxisCount = constraints.maxWidth > 1300
              ? 5
              : constraints.maxWidth > 800
              ? 3
              : 1;
          // Adjust aspect ratio so charts aren't too squashed
          double aspectRatio = constraints.maxWidth > 1300
              ? 0.85
              : constraints.maxWidth > 800
              ? 1 / 1
              : 1 / 0.8;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // --- SECTION 1: GLOBAL SUMMARY (TOP) ---
              const Text(
                "Global Vulnerability Severity",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Obx(() {
                if (controller.isLoading.value) {
                  return const SizedBox(
                    height: 260,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return SizedBox(
                  height: 260,
                  child: SeverityPieChart(
                    SeverityModel(
                      controller.critical.value,
                      controller.high.value,
                      controller.medium.value,
                      controller.low.value,
                      controller.info.value,
                    ),
                  ),
                );
              }),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Divider(thickness: 1.5),
              ),

              // --- SECTION 2: ENVIRONMENT BREAKDOWN (GRID) ---
              const Text(
                "Environment Breakdown",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Obx(() {
                // Independent loader for breakdown section
                if (controller.isLoadingEnv.value) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // Null check for the list
                if (controller.envdata.value == null ||
                    controller.envdata.value!.data.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("No environment data available"),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true, // Allows GridView to live inside a ListView
                  physics:
                      const NeverScrollableScrollPhysics(), // ListView handles scroll
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: controller.envdata.value!.data.length,
                  itemBuilder: (context, index) {
                    // Correctly access the individual environment data
                    final env = controller.envdata.value!.data[index];

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              env.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Divider(),
                            Expanded(
                              child: SeverityPieChart(
                                SeverityModel(
                                  env.critical, // Accessed from 'env' variable
                                  env.high, // This fixes your undefined_getter error
                                  env.medium,
                                  env.low,
                                  0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
