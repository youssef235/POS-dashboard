import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  final String title;
  final String amount;
  final String change;

  const OverviewCard({
    required this.title,
    required this.amount,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              change,
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
