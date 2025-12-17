import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vulntrack_app/controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Global Vulnerability Severity",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 260,
                child: _SeverityPieChart(controller: controller),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/* ---------------- PIE CHART (INLINE) ---------------- */

class _SeverityPieChart extends StatefulWidget {
  final HomeController controller;

  const _SeverityPieChart({required this.controller});

  @override
  State<_SeverityPieChart> createState() => _SeverityPieChartState();
}

class _SeverityPieChartState extends State<_SeverityPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;

    final total =
        c.critical.value +
        c.high.value +
        c.medium.value +
        c.low.value +
        c.info.value;

    if (total == 0) {
      return const Center(child: Text("No vulnerability data"));
    }

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (event, response) {
            setState(() {
              touchedIndex =
                  response?.touchedSection?.touchedSectionIndex ?? -1;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: _sections(c, total),
      ),
    );
  }

  List<PieChartSectionData> _sections(HomeController c, int total) {
    return [
      _section(0, c.critical.value, Colors.red, total, "Critical"),
      _section(1, c.high.value, Colors.orange, total, "High"),
      _section(2, c.medium.value, Colors.yellow.shade700, total, "Medium"),
      _section(3, c.low.value, Colors.green, total, "Low"),
      _section(4, c.info.value, Colors.blueGrey, total, "Info"),
    ];
  }

  PieChartSectionData _section(
    int index,
    int value,
    Color color,
    int total,
    String label,
  ) {
    final isTouched = index == touchedIndex;
    final percentage = ((value / total) * 100).toStringAsFixed(1);

    return PieChartSectionData(
      color: color,
      value: value.toDouble(),
      radius: isTouched ? 70 : 60,
      title: "$label\n$percentage%",
      titleStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
