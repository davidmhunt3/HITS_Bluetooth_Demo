import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 140,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 1),
                FlSpot(1, 1),
                FlSpot(2, 1),
                FlSpot(3, 1),
                FlSpot(4, 1),
                FlSpot(5, 1),
                FlSpot(6, 1),
                FlSpot(7, .4),
                FlSpot(8, .2),
                FlSpot(9, .7),
                FlSpot(10, 1),
                FlSpot(11, 1),
              ],
              isCurved: true,
              barWidth: 3,
              colors: [
                Colors.green,
              ],
              dotData: FlDotData(
                show: false,
              ),
            ),
            LineChartBarData(
              spots: [
                FlSpot(0, 0.1),
                FlSpot(1, 0.1),
                FlSpot(2, 0.1),
                FlSpot(3, 0.1),
                FlSpot(4, 0.1),
                FlSpot(5, 5),
                FlSpot(6, 7),
                FlSpot(7, 5),
                FlSpot(8, 2),
                FlSpot(9, 0.1),
                FlSpot(10, 0.1),
                FlSpot(11, 0.1),
              ],
              isCurved: true,
              barWidth: 3,
              colors: [
                Colors.lightBlue,
              ],
              dotData: FlDotData(
                show: false,
              ),
            ),
            LineChartBarData(
              spots: [
                FlSpot(0, 0.1),
                FlSpot(1, 0.1),
                FlSpot(2, 0.1),
                FlSpot(3, 0.1),
                FlSpot(4, 0.1),
                FlSpot(5, 0.1),
                FlSpot(6, 0.1),
                FlSpot(7, 0.1),
                FlSpot(8, 0.1),
                FlSpot(9, 0.1),
                FlSpot(10, 0.1),
                FlSpot(11, 0.1),
              ],
              isCurved: true,
              barWidth: 3,
              colors: [
                Colors.red,
              ],
              dotData: FlDotData(
                show: false,
              ),
            ),
          ],
          minY: 0,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                interval: 5,
                getTitles: (value) {
                  return value.toString();
                }),
            leftTitles: SideTitles(
              showTitles: true,
              textStyle: TextStyle(color: Colors.white, fontSize: 11.0),
              interval: 1,
              getTitles: (value) {
                return value.toString();
              },
            ),
          ),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }
}
