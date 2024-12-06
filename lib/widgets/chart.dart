import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/chart_stats.dart';

class BarChartSample extends StatelessWidget {
  final String title;
  final Color leftBarColor;
  final Color rightBarColor;
  final Color avgColor;
  final Map<String, ChartStats> data;

  const BarChartSample({
    required this.title,
    required this.leftBarColor,
    required this.rightBarColor,
    required this.avgColor,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> barGroups = [];
    final List<String> timeLabels = [];

    int index = 0;
    data.forEach((time, stats) {
      barGroups.add(makeGroupData(index, stats.temperature, stats.ammonia));
      timeLabels.add(time);
      index++;
    });

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.7,
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= timeLabels.length) {
                        return const SizedBox();
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          timeLabels[index],
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    const double barWidth = 8;
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: leftBarColor,
          width: barWidth,
        ),
        BarChartRodData(
          toY: y2,
          color: rightBarColor,
          width: barWidth,
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.yellow,
          width: barWidth,
        ),
      ],
    );
  }
}
