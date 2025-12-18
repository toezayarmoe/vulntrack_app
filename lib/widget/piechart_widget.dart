import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vulntrack_app/models/severity_model.dart';

class SeverityPieChart extends StatefulWidget {
  final SeverityModel data;

  const SeverityPieChart(this.data, {super.key});

  @override
  State<SeverityPieChart> createState() => _SeverityPieChartState();
}

class _SeverityPieChartState extends State<SeverityPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final c = widget.data;
    final total = c.critical + c.high + c.medium + c.low + c.info;

    if (total == 0) {
      return const Center(child: Text("No vulnerability data"));
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 18),
          // Row of Indicators (Legend)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildIndicator(0, Colors.red, "Crit"),
              _buildIndicator(1, Colors.orange, "High"),
              _buildIndicator(2, Colors.yellow.shade700, "Med"),
              _buildIndicator(3, Colors.green, "Low"),
              _buildIndicator(4, Colors.blueGrey, "Info"),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
                      });
                    },
                  ),
                  startDegreeOffset: 180,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 1,
                  centerSpaceRadius:
                      0, // Set to 0 for a solid Pie, or 40 for Donut
                  sections: _showingSections(c, total),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build the legend indicators
  Widget _buildIndicator(int index, Color color, String text) {
    final isSelected = touchedIndex == index;
    return Row(
      children: [
        Container(
          width: isSelected ? 16 : 12,
          height: isSelected ? 16 : 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _showingSections(SeverityModel c, int total) {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched ? 85 : 75;

      // Define data per index
      final data = switch (i) {
        0 => (
          color: Colors.red,
          value: c.critical.toDouble(),
          label: "Critical",
        ),
        1 => (color: Colors.orange, value: c.high.toDouble(), label: "High"),
        2 => (
          color: Colors.yellow.shade700,
          value: c.medium.toDouble(),
          label: "Med",
        ),
        3 => (color: Colors.green, value: c.low.toDouble(), label: "Low"),
        4 => (color: Colors.blueGrey, value: c.info.toDouble(), label: "Info"),
        _ => throw StateError('Invalid index'),
      };

      return PieChartSectionData(
        color: data.color,
        value: data.value,
        title: isTouched
            ? '${data.label}\n${((data.value / total) * 100).toStringAsFixed(0)}%'
            : '',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        borderSide: isTouched
            ? const BorderSide(color: Colors.white, width: 4)
            : BorderSide(color: Colors.white),
      );
    });
  }
}
