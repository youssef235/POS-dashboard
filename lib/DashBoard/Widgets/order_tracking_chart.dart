import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OrderTrackingChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
              x: 0, barRods: [BarChartRodData(toY: 200, color: Colors.blue)]),
          BarChartGroupData(
              x: 1, barRods: [BarChartRodData(toY: 150, color: Colors.blue)]),
          BarChartGroupData(
              x: 2, barRods: [BarChartRodData(toY: 300, color: Colors.blue)]),
          BarChartGroupData(
              x: 3, barRods: [BarChartRodData(toY: 250, color: Colors.blue)]),
          BarChartGroupData(
              x: 4, barRods: [BarChartRodData(toY: 400, color: Colors.blue)]),
        ],
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}
