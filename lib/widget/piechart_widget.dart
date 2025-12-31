import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vulntrack_app/models/severity_model.dart';

class SeverityPieChart extends StatefulWidget {
  final SeverityModel data;
  final bool isCompact;

  const SeverityPieChart(this.data, {super.key, this.isCompact = false});

  @override
  State<SeverityPieChart> createState() => _SeverityPieChartState();
}

class _SeverityPieChartState extends State<SeverityPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final int total =
        widget.data.critical +
        widget.data.high +
        widget.data.medium +
        widget.data.low +
        widget.data.info;

    if (total == 0) {
      return Center(
        child: Text("No Data", style: TextStyle(color: Colors.grey[400])),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
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
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: widget.isCompact ? 30 : 50,
                  sections: _buildSections(total),
                ),
                // FIXED: API Updated in latest fl_chart
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              _buildCenterText(total),
            ],
          ),
        ),
        if (!widget.isCompact) ...[
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              _LegendItem(
                "Crit",
                const Color(0xFFEF5350),
                widget.data.critical,
              ),
              _LegendItem("High", const Color(0xFFFFA726), widget.data.high),
              _LegendItem("Med", const Color(0xFFFFEE58), widget.data.medium),
              _LegendItem("Low", const Color(0xFF66BB6A), widget.data.low),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCenterText(int total) {
    String label = "Total";
    String value = "$total";
    Color color = Colors.blueGrey[800]!;

    if (touchedIndex != -1) {
      switch (touchedIndex) {
        case 0:
          label = "Critical";
          value = "${widget.data.critical}";
          color = const Color(0xFFEF5350);
          break;
        case 1:
          label = "High";
          value = "${widget.data.high}";
          color = const Color(0xFFFFA726);
          break;
        case 2:
          label = "Medium";
          value = "${widget.data.medium}";
          color = const Color(0xFFFFEE58);
          break;
        case 3:
          label = "Low";
          value = "${widget.data.low}";
          color = const Color(0xFF66BB6A);
          break;
        case 4:
          label = "Info";
          value = "${widget.data.info}";
          color = const Color(0xFF90A4AE);
          break;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: widget.isCompact ? 20 : 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(int total) {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched
          ? (widget.isCompact ? 25 : 35)
          : (widget.isCompact ? 18 : 28);
      switch (i) {
        case 0:
          return _section(
            widget.data.critical,
            const Color(0xFFEF5350),
            radius,
          );
        case 1:
          return _section(widget.data.high, const Color(0xFFFFA726), radius);
        case 2:
          return _section(widget.data.medium, const Color(0xFFFFEE58), radius);
        case 3:
          return _section(widget.data.low, const Color(0xFF66BB6A), radius);
        case 4:
          return _section(widget.data.info, const Color(0xFF90A4AE), radius);
        default:
          throw Error();
      }
    });
  }

  PieChartSectionData _section(int value, Color color, double radius) {
    return PieChartSectionData(
      color: color,
      value: value.toDouble(),
      title: '',
      radius: radius,
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final int value;
  const _LegendItem(this.label, this.color, this.value);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          "$label ($value)",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
