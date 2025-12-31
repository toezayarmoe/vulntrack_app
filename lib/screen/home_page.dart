import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/controllers/home_controller.dart';
import 'package:vulntrack_app/models/severity_model.dart';
import 'package:vulntrack_app/widget/piechart_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A clean, light-grey background common in modern web dashboards
    final Color backgroundColor = const Color(0xFFF3F4F6);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop breakpoint > 900px
        bool isDesktop = constraints.maxWidth > 900;

        return Scaffold(
          backgroundColor: backgroundColor,
          // Mobile: Show standard AppBar + Drawer
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
          drawer: isDesktop ? null : const _SidebarMenu(),

          // Body Layout
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SIDEBAR (Only visible on Desktop)
              if (isDesktop) const SizedBox(width: 250, child: _SidebarMenu()),

              // 2. MAIN CONTENT AREA
              Expanded(
                child: Column(
                  children: [
                    // Desktop Header (Breadcrumbs, Search, Profile)
                    if (isDesktop) const _WebHeader(),

                    // Scrollable Dashboard Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SectionTitle(title: "Global Overview"),
                            const SizedBox(height: 16),

                            // --- GLOBAL CHART CARD ---
                            _buildGlobalSummaryCard(controller),

                            const SizedBox(height: 32),
                            const _SectionTitle(title: "Environments"),
                            const SizedBox(height: 16),

                            // --- ENVIRONMENT GRID ---
                            _buildEnvironmentGrid(
                              controller,
                              constraints.maxWidth,
                              isDesktop,
                            ),

                            // Bottom spacing
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

  // --- WIDGET BUILDERS ---

  Widget _buildGlobalSummaryCard(HomeController controller) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Row(
          children: [
            // Left Side: Text Information
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Vulnerability Status",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
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
                    // Status Indicators
                    Row(
                      children: [
                        _StatBadge(
                          "Critical",
                          controller.critical.value,
                          const Color(0xFFEF5350),
                        ),
                        const SizedBox(width: 24),
                        _StatBadge(
                          "High",
                          controller.high.value,
                          const Color(0xFFFFA726),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Divider
            VerticalDivider(width: 1, color: Colors.grey.shade100),
            // Right Side: Large Chart
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SeverityPieChart(
                  SeverityModel(
                    controller.critical.value,
                    controller.high.value,
                    controller.medium.value,
                    controller.low.value,
                    controller.info.value,
                  ),
                  isCompact: false, // Show detailed labels
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEnvironmentGrid(
    HomeController controller,
    double screenWidth,
    bool isDesktop,
  ) {
    // Dynamic Grid Calculation
    double sidebarWidth = isDesktop ? 250 : 0;
    double availableWidth = screenWidth - sidebarWidth - 48; // padding

    int crossAxisCount = availableWidth > 1400
        ? 4
        : availableWidth > 1000
        ? 3
        : availableWidth > 600
        ? 2
        : 1;

    return Obx(() {
      if (controller.isLoadingEnv.value) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (controller.envdata.value == null ||
          controller.envdata.value!.data.isEmpty) {
        return const Center(child: Text("No environment data available"));
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.envdata.value!.data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.95, // Boxy shape
        ),
        itemBuilder: (context, index) {
          final env = controller.envdata.value!.data[index];
          final int totalIssues =
              env.critical + env.high + env.medium + env.low;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.dns_rounded,
                          size: 18,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          env.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Card Body (Chart)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SeverityPieChart(
                      SeverityModel(
                        env.critical,
                        env.high,
                        env.medium,
                        env.low,
                        0,
                      ),
                      isCompact: true, // IMPORTANT: Clean look for small cards
                    ),
                  ),
                ),

                // Card Footer
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade100),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Issues",
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "$totalIssues",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
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
    });
  }
}

// --- PRIVATE COMPONENTS (Keep these in the file for easy copy-paste) ---

class _SidebarMenu extends StatelessWidget {
  const _SidebarMenu();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Logo Area
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_moon_rounded,
                  color: Colors.indigo,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  "VulnTrack",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Menu
          const _SidebarItem(
            icon: Icons.dashboard_rounded,
            label: "Dashboard",
            isActive: true,
          ),
          const _SidebarItem(
            icon: Icons.list_alt_rounded,
            label: "Scans",
            isActive: false,
          ),
          const _SidebarItem(
            icon: Icons.analytics_outlined,
            label: "Reports",
            isActive: false,
          ),
          const _SidebarItem(
            icon: Icons.settings_outlined,
            label: "Settings",
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? Colors.indigo.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: isActive ? Colors.indigo : Colors.grey[500],
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.indigo : Colors.grey[700],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _WebHeader extends StatelessWidget {
  const _WebHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Text(
            "Overview / ",
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const Text(
            "Dashboard",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Colors.grey[400]),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none, color: Colors.grey[400]),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.indigo.shade100,
            child: const Text(
              "A",
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey[500],
        letterSpacing: 1.2,
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatBadge(this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        Text(
          "$count",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
