import 'package:flutter/material.dart';
import 'package:vulntrack_app/models/severity_model.dart';

class SeverityStatusBar extends StatelessWidget {
  final SeverityModel data;
  final double height;

  const SeverityStatusBar({super.key, required this.data, this.height = 12});

  @override
  Widget build(BuildContext context) {
    final int total =
        data.critical + data.high + data.medium + data.low + data.info;

    // If no data, show a grey empty bar
    if (total == 0) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            if (data.critical > 0)
              _buildSegment(data.critical, total, const Color(0xFFEF5350)),
            if (data.high > 0)
              _buildSegment(data.high, total, const Color(0xFFFFA726)),
            if (data.medium > 0)
              _buildSegment(data.medium, total, const Color(0xFFFFEE58)),
            if (data.low > 0)
              _buildSegment(data.low, total, const Color(0xFF66BB6A)),
            if (data.info > 0)
              _buildSegment(data.info, total, const Color(0xFF90A4AE)),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment(int value, int total, Color color) {
    return Expanded(
      // The flex factor handles the percentage calculation automatically!
      flex: value,
      child: Tooltip(
        message: "$value",
        child: Container(color: color),
      ),
    );
  }
}
