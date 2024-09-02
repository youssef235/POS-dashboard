import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RevenueChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 200,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 100),
            FlSpot(1, 150),
            FlSpot(2, 120),
            FlSpot(3, 170),
            FlSpot(4, 130),
            FlSpot(5, 180),
            FlSpot(6, 160),
          ],
          isCurved: true,
          color: Colors.blue,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    ));
  }
}
