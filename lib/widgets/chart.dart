import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample extends StatelessWidget {
  final String title;
  final Color leftBarColor;
  final Color rightBarColor;
  final Color avgColor;

  const BarChartSample({
    required this.title,
    required this.leftBarColor,
    required this.rightBarColor,
    required this.avgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.7,
          child: BarChart(
            BarChartData(
              barGroups: [
                makeGroupData(0, 70, 30), // Contoh nilai
                makeGroupData(1, 60, 40),
                makeGroupData(2, 80, 50),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles:
                      SideTitles(showTitles: true, getTitlesWidget: leftTitles),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true, getTitlesWidget: bottomTitles),
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

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontSize: 14,
    );
    String text = value.toInt().toString();
    return SideTitleWidget(
        axisSide: meta.axisSide, space: 8, child: Text(text, style: style));
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const titles = <String>['Mn', 'Tu', 'Wd', 'Th', 'Fr', 'St', 'Su'];
    final index = value.toInt();
    if (index < 0 || index >= titles.length) return Container();
    final Widget text = Text(
      titles[index],
      style: const TextStyle(color: Colors.black, fontSize: 14),
    );
    return SideTitleWidget(axisSide: meta.axisSide, space: 8, child: text);
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    const double barWidth = 10;
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
      ],
    );
  }
}
