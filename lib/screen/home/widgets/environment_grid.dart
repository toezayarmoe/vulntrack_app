import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/controllers/home_controller.dart';
import 'package:vulntrack_app/models/severity_model.dart';
import 'package:vulntrack_app/widget/severity_bar_widget.dart';

class EnvironmentGrid extends StatelessWidget {
  final HomeController controller;
  final double screenWidth;
  final bool isDesktop;

  const EnvironmentGrid({
    super.key,
    required this.controller,
    required this.screenWidth,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    double sidebarWidth = isDesktop ? 250 : 0;
    double availableWidth = screenWidth - sidebarWidth - 48;

    // Responsive Logic
    int crossAxisCount = availableWidth > 1400
        ? 4
        : availableWidth > 900
        ? 3
        : availableWidth > 600
        ? 2
        : 1;
    double childAspectRatio = availableWidth > 600 ? 1.3 : 1.5;

    return Obx(() {
      if (controller.isLoadingEnv.value) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (controller.envdata.value == null ||
          controller.envdata.value!.data.isEmpty) {
        return const Center(child: Text("No Environment Data"));
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.envdata.value!.data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          final env = controller.envdata.value!.data[index];
          final int totalIssues =
              env.critical + env.high + env.medium + env.low;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.dns_rounded,
                        size: 20,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            env.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Last Scan: 2 hrs ago",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Bar & Label
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Security Health",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "$totalIssues Issues",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SeverityStatusBar(
                      data: SeverityModel(
                        env.critical,
                        env.high,
                        env.medium,
                        env.low,
                        0,
                      ),
                      height: 12,
                    ),
                  ],
                ),

                const Spacer(),
                const Divider(height: 1),
                const Spacer(),

                // Stats Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatColumn("Critical", env.critical, Colors.red.shade400),
                    _StatColumn("High", env.high, Colors.orange.shade400),
                    _StatColumn("Medium", env.medium, Colors.yellow.shade700),
                    _StatColumn("Low", env.low, Colors.green.shade400),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatColumn(this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: count > 0 ? Colors.black87 : Colors.grey[400],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
