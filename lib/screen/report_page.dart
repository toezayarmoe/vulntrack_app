import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/controllers/reports_controller.dart';
import 'package:vulntrack_app/models/report_model.dart';
import 'package:vulntrack_app/widget/sidebar_menu.dart';
import 'package:vulntrack_app/widget/web_header.dart';
// NOTE: Make sure to import your sidebar/header correctly or use the code provided previously

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportsController());
    final Color backgroundColor = const Color(0xFFF3F4F6);

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: isDesktop
              ? null
              : AppBar(
                  backgroundColor: Colors.white,
                  elevation: 1,
                  title: const Text(
                    'Reports',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconTheme: const IconThemeData(color: Colors.black87),
                ),
          // Placeholder for Sidebar if not using shared widget
          drawer: isDesktop
              ? null
              : const Drawer(child: Center(child: Text("Sidebar"))),

          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop) const SizedBox(width: 250, child: SidebarMenu()),

              Expanded(
                child: Column(
                  children: [
                    if (isDesktop)
                      Container(
                        height: 70,
                        color: Colors.white,
                        child: WebHeader(title: "Reports", subtitle: ""),
                      ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GENERATED REPORTS",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500],
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Obx(() {
                              if (controller.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (controller.reports.isEmpty) {
                                return const Center(
                                  child: Text("No reports found"),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.reports.length,
                                itemBuilder: (context, index) {
                                  final report = controller.reports[index];
                                  return _buildReportCard(report);
                                },
                              );
                            }),

                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportCard(ReportModel report) {
    // logic to parse date from filename
    String dateString = "Unknown Date";
    final RegExp dateRegex = RegExp(r'(\d{1,2})[-_](\d{1,2})[-_](\d{4})');
    final match = dateRegex.firstMatch(report.name);
    if (match != null) {
      dateString = "${match.group(1)}/${match.group(2)}/${match.group(3)}";
    }

    String displayName = report.name
        .replaceAll(RegExp(r'(\d{1,2})[-_](\d{1,2})[-_](\d{4})'), '')
        .replaceAll('_', ' ')
        .trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.picture_as_pdf, color: Colors.red),
          ),
          const SizedBox(width: 16),

          // Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName.isEmpty ? report.name : displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateString,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // DOWNLOAD BUTTON REMOVED HERE
        ],
      ),
    );
  }
}
