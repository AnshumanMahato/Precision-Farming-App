import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// fl_charts

class Graphs extends StatefulWidget {
  const Graphs({super.key});

  @override
  State<Graphs> createState() =>
      _GraphsState();
}

class _GraphsState
    extends State<Graphs> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView( padding: EdgeInsets.all(20),
      children: [
        AspectRatio(aspectRatio: 2.5,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(1, 3),
                  FlSpot(2, 1.5),
                  FlSpot(3, 6),
                  FlSpot(4, 5),
                  FlSpot(5, 7),
                ],
                color: Colors.red,
                gradient: const LinearGradient(colors: [Colors.red , Colors.purpleAccent , Colors.orange],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter
                ) ,
                barWidth: 2,
                isCurved: true,
                curveSmoothness: 0.35,
                preventCurveOverShooting: true,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.red.withOpacity(.2)
                )
                
              )
            ]
          )
        ),)
      ],)
      );
      
    
  }
}