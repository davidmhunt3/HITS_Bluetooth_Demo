import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hits_bluetooth_demo/Cards_Widgets/ChartCard.dart';

class Chart extends StatelessWidget {
  List<SeriesData> chartData;
  int numCharts;

  Chart({@required this.chartData, @required this.numCharts});

  List<FlSpot> listToFlSpot(List<double> list) {
    List<FlSpot> retList = [];
    for (int i = 0; i < list.length; i++) {
      retList.add(FlSpot(i.toDouble(), list[i]));
    }
    return retList;
  }

  List<LineChartBarData> generateChartData(
      List<SeriesData> chartData, int numCharts) {
    List<LineChartBarData> retList = [];
    for (int i = 0; i < numCharts; i++) {
      retList.add(
        LineChartBarData(
          spots: listToFlSpot(chartData[i].series),
          isCurved: true,
          barWidth: 3,
          colors: [
            chartData[i].color,
          ],
          dotData: FlDotData(
            show: false,
          ),
        ),
      );
    }
    return retList;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 140,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: false),
          lineBarsData: generateChartData(chartData, numCharts),
          minY: 0,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                interval: 2.5,
                getTitles: (value) {
                  return '${value.toStringAsFixed(1)}s';
                }),
            leftTitles: SideTitles(
              showTitles: true,
              textStyle: TextStyle(color: Colors.white, fontSize: 11.0),
              interval: 3,
              getTitles: (value) {
                return '${value.toInt()}';
              },
            ),
          ),
          gridData: FlGridData(
              show: true,
              checkToShowHorizontalLine: (value) {
                return (value % 3) == 0;
              }),
        ),
      ),
    );
  }
}

//[
//LineChartBarData(
//spots: [
//FlSpot(0, 1),
//FlSpot(1, 1),
//FlSpot(2, 1),
//FlSpot(3, 1),
//FlSpot(4, 1),
//FlSpot(5, 1),
//FlSpot(6, 1),
//FlSpot(7, .4),
//FlSpot(8, .2),
//FlSpot(9, .7),
//FlSpot(10, 1),
//FlSpot(11, 1),
//],
//isCurved: true,
//barWidth: 3,
//colors: [
//Colors.green,
//],
//dotData: FlDotData(
//show: false,
//),
//),
//LineChartBarData(
//spots: [
//FlSpot(0, 0.1),
//FlSpot(1, 0.1),
//FlSpot(2, 0.1),
//FlSpot(3, 0.1),
//FlSpot(4, 0.1),
//FlSpot(5, 5),
//FlSpot(6, 7),
//FlSpot(7, 5),
//FlSpot(8, 2),
//FlSpot(9, 0.1),
//FlSpot(10, 0.1),
//FlSpot(11, 0.1),
//],
//isCurved: true,
//barWidth: 3,
//colors: [
//Colors.lightBlue,
//],
//dotData: FlDotData(
//show: false,
//),
//),
//LineChartBarData(
//spots: [
//FlSpot(0, 0.1),
//FlSpot(1, 0.1),
//FlSpot(2, 0.1),
//FlSpot(3, 0.1),
//FlSpot(4, 0.1),
//FlSpot(5, 0.1),
//FlSpot(6, 0.1),
//FlSpot(7, 0.1),
//FlSpot(8, 0.1),
//FlSpot(9, 0.1),
//FlSpot(10, 0.1),
//FlSpot(11, 0.1),
//],
//isCurved: true,
//barWidth: 3,
//colors: [
//Colors.red,
//],
//dotData: FlDotData(
//show: false,
//),
//),
//],
