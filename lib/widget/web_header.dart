import 'package:flutter/material.dart';

class WebHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const WebHeader({super.key, required this.title, required this.subtitle});

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
            subtitle, // Dynamic Subtitle (e.g., "Overview / ")
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          Text(
            title, // Dynamic Title (e.g., "Dashboard")
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
