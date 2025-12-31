import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/controllers/home_controller.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    // Get the current route name to determine which item is active
    final String currentRoute = Get.currentRoute;

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

          // --- MENU ITEMS ---
          SidebarItem(
            icon: Icons.dashboard_rounded,
            label: "Dashboard",
            // Active if route is '/' (default) or '/HomeScreen'
            isActive: currentRoute == '/' || currentRoute == '/HomeScreen',
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) Get.back();
              // Navigate and reset stack to Home
              Get.offAllNamed('/home');
            },
          ),
          SidebarItem(
            icon: Icons.list_alt_rounded,
            label: "Scans",
            isActive: currentRoute == '/ScansPage',
            onTap: () {},
          ),
          SidebarItem(
            icon: Icons.analytics_outlined,
            label: "Reports",
            // Active if route is '/ReportsPage'
            isActive: currentRoute == '/ReportsPage',
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) Get.back();
              // Prevent navigating if already on the page
              Get.toNamed('/report');
            },
          ),
          SidebarItem(
            icon: Icons.settings_outlined,
            label: "Settings",
            isActive: currentRoute == '/SettingsPage',
            onTap: () {},
          ),

          const Spacer(),
          const Divider(),

          SidebarItem(
            icon: Icons.logout,
            label: "Logout",
            isActive: false,
            onTap: () => controller.logout(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isActive ? Colors.indigo.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          ),
        ),
      ),
    );
  }
}
