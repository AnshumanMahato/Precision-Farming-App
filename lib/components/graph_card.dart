import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class GraphCard extends StatelessWidget {
  final List<Map<String, dynamic>> farmData;
  final String title;
  final String field;
  final Color color;

  const GraphCard(
      {super.key,
      required this.farmData,
      required this.title,
      required this.field,
      required this.color});

  @override
  Widget build(BuildContext context) {
    // Calculate min and max values for the Y-axis
    final yValues = farmData.map((data) => data[field].toDouble()).toList();
    final double minY =
        yValues.isEmpty ? 0 : yValues.reduce((a, b) => a < b ? a : b) - 0.1;
    final maxY =
        yValues.isEmpty ? 100 : yValues.reduce((a, b) => a > b ? a : b) + 0.1;

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
          SizedBox(
            height: 300, // Height for the graph
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
                            final formattedTime =
                                DateFormat('HH:mm').format(time);
                            return Text(formattedTime,
                                style: const TextStyle(fontSize: 10));
                          }
                          return const Text('');
                        },
                        reservedSize: 40,
                        interval: 10,
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
                            entry.value[field].toDouble(),
                          ),
                        )
                        .toList(),
                    isCurved: true,
                    color: color,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    preventCurveOverShooting: true,
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
        ],
      ),
    );
  }
}
