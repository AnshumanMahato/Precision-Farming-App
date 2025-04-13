import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalysisCard extends StatelessWidget {
  final List<Map<String, dynamic>> farmData;
  final String title;
  final String field;
  final String timeRange;

  const AnalysisCard(
      {super.key,
      required this.farmData,
      required this.title,
      required this.field,
      required this.timeRange});

  @override
  Widget build(BuildContext context) {
    // Calculate min and max values for the Y-axis
    final maxYValues =
        farmData.map((data) => data[field]["max"].toDouble()).toList();
    final minYValues =
        farmData.map((data) => data[field]["min"].toDouble()).toList();
    final double minY = minYValues.isEmpty
        ? 0
        : minYValues.reduce((a, b) => a < b ? a : b) - 0.1;
    final maxY = maxYValues.isEmpty
        ? 100
        : maxYValues.reduce((a, b) => a > b ? a : b) + 0.1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < farmData.length) {
                            final timestamp = farmData[value.toInt()]['date'];
                            final time = DateTime.parse(timestamp);
                            final formattedTime = timeRange == "1d"
                                ? DateFormat('HH:mm').format(time)
                                : DateFormat('dd/MM').format(time);
                            return Text(formattedTime,
                                style: const TextStyle(fontSize: 10));
                          }
                          return const Text('');
                        },
                        reservedSize: 40,
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    )),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: farmData
                        .asMap()
                        .entries
                        .map(
                          (entry) => FlSpot(
                            entry.key.toDouble(),
                            entry.value[field]["max"].toDouble(),
                          ),
                        )
                        .toList(),
                    isCurved: true,
                    color: Colors.red,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    preventCurveOverShooting: true,
                  ),
                  LineChartBarData(
                    spots: farmData
                        .asMap()
                        .entries
                        .map(
                          (entry) => FlSpot(
                            entry.key.toDouble(),
                            entry.value[field]["min"].toDouble(),
                          ),
                        )
                        .toList(),
                    isCurved: true,
                    color: Colors.blue,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: farmData
                        .asMap()
                        .entries
                        .map(
                          (entry) => FlSpot(
                            entry.key.toDouble(),
                            entry.value[field]["avg"].toDouble(),
                          ),
                        )
                        .toList(),
                    isCurved: true,
                    color: Colors.green,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                minY: double.parse(
                    minY.toStringAsFixed(2)), // Set minimum value for Y-axis
                maxY: double.parse(
                    maxY.toStringAsFixed(2)), // Set maximum value for Y-axis
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots
                          .map(
                            (touchedSpot) => LineTooltipItem(
                              touchedSpot.y.toString(),
                              const TextStyle(color: Colors.white),
                            ),
                          )
                          .toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LegendItem(color: Colors.red, text: 'Max'),
                SizedBox(width: 20),
                LegendItem(color: Colors.blue, text: 'Average'),
                SizedBox(width: 20),
                LegendItem(color: Colors.green, text: 'Min'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
