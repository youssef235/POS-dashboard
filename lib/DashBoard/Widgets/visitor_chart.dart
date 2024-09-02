import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VisitorChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 300000,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 200000),
            FlSpot(1, 250000),
            FlSpot(2, 300000),
            FlSpot(3, 280000),
            FlSpot(4, 320000),
            FlSpot(5, 290000),
            FlSpot(6, 310000),
          ],
          isCurved: true,
          color: Colors.green,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    ));
  }
}
