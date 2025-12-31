import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/controllers/home_controller.dart';
import 'package:vulntrack_app/models/severity_model.dart';
import 'package:vulntrack_app/widget/piechart_widget.dart';
import 'status_badge.dart';

class GlobalSummaryCard extends StatelessWidget {
  final HomeController controller;
  final bool isMobile;

  const GlobalSummaryCard({
    super.key,
    required this.controller,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMobile ? null : 320,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // --- CONTENT PIECES ---

        // 1. Text Info
        final textSection = Padding(
          padding: EdgeInsets.all(isMobile ? 24.0 : 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Vulnerability Status",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                "Real-time aggregation of security threats across all registered environments.",
                style: TextStyle(
                  color: Colors.grey[600],
                  height: 1.5,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 24,
                runSpacing: 12,
                children: [
                  StatusBadge(
                    label: "Critical",
                    count: controller.critical.value,
                    color: const Color(0xFFEF5350),
                  ),
                  StatusBadge(
                    label: "High",
                    count: controller.high.value,
                    color: const Color(0xFFFFA726),
                  ),
                ],
              ),
            ],
          ),
        );

        // 2. Chart Info
        final chartSection = Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            height: isMobile ? 250 : null,
            child: SeverityPieChart(
              SeverityModel(
                controller.critical.value,
                controller.high.value,
                controller.medium.value,
                controller.low.value,
                controller.info.value,
              ),
              isCompact: false,
            ),
          ),
        );

        // --- LAYOUT LOGIC ---
        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textSection,
              Divider(height: 1, color: Colors.grey.shade100),
              chartSection,
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(flex: 2, child: textSection),
              VerticalDivider(width: 1, color: Colors.grey.shade100),
              Expanded(flex: 3, child: chartSection),
            ],
          );
        }
      }),
    );
  }
}
