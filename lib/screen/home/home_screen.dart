import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/controllers/home_controller.dart';
import 'package:vulntrack_app/widget/sidebar_menu.dart';
import 'package:vulntrack_app/widget/web_header.dart';
// Imports for our clean widgets
import 'widgets/global_summary_card.dart';
import 'widgets/environment_grid.dart';
import 'widgets/section_title.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define breakpoints
        bool isDesktop = constraints.maxWidth > 900;
        bool isMobile = constraints.maxWidth < 600;

        return Scaffold(
          backgroundColor: const Color(0xFFF3F4F6),
          // Mobile App Bar
          appBar: isDesktop
              ? null
              : AppBar(
                  backgroundColor: Colors.white,
                  elevation: 1,
                  title: const Text(
                    'VulnTrack',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconTheme: const IconThemeData(color: Colors.black87),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () => controller.logout(),
                    ),
                  ],
                ),
          // Mobile Drawer
          drawer: isDesktop ? null : const SidebarMenu(),

          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Desktop Sidebar
              if (isDesktop) const SizedBox(width: 250, child: SidebarMenu()),

              // Main Content Area
              Expanded(
                child: Column(
                  children: [
                    if (isDesktop)
                      const WebHeader(subtitle: "", title: "Dashboard"),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(isMobile ? 16 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionTitle(title: "Global Overview"),
                            const SizedBox(height: 16),

                            // Global Summary Widget
                            GlobalSummaryCard(
                              controller: controller,
                              isMobile: isMobile,
                            ),

                            const SizedBox(height: 32),
                            const SectionTitle(title: "Environments"),
                            const SizedBox(height: 16),

                            // Environment Grid Widget
                            EnvironmentGrid(
                              controller: controller,
                              screenWidth: constraints.maxWidth,
                              isDesktop: isDesktop,
                            ),

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
}
