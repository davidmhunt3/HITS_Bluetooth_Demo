import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hits_bluetooth_demo/Cards_Widgets/ChartCard.dart';

class Chart extends StatelessWidget {
  List<SeriesData> chartData;
  int numCharts;
  Stream<List<List<double>>> seriesDataStream;
  double chartLeftTitleInterval;

  Chart(
      {@required this.chartData,
      @required this.numCharts,
      @required this.seriesDataStream,
      @required this.chartLeftTitleInterval});

  List<FlSpot> listToFlSpot(List<double> list) {
    List<FlSpot> retList = [];
    for (int i = 0; i < list.length; i++) {
      retList.add(FlSpot(i.toDouble(), list[i].abs()));
    }
    return retList;
  }

  List<LineChartBarData> generateChartData(List<SeriesData> chartData,
      int numCharts, List<List<double>> seriesDataValues) {
    List<LineChartBarData> retList = [];
    for (int i = 0; i < numCharts; i++) {
      retList.add(
        LineChartBarData(
          spots: listToFlSpot(seriesDataValues[i]),
          isCurved: false,
          barWidth: 2,
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
        child: StreamBuilder<List<List<double>>>(
          stream: seriesDataStream,
          initialData: [
            [0],
            [0],
            [0],
          ],
          builder: (context, snapshot) {
            return LineChart(
              LineChartData(
                lineTouchData: LineTouchData(enabled: false),
                lineBarsData:
                    generateChartData(chartData, numCharts, snapshot.data),
                minY: 0,
                titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                      showTitles: true,
                      textStyle: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      interval: 500,
                      getTitles: (value) {
                        return '${value.toStringAsFixed(1)}ms';
                      }),
                  leftTitles: SideTitles(
                    showTitles: true,
                    textStyle: TextStyle(color: Colors.white, fontSize: 11.0),
                    interval: chartLeftTitleInterval,
                    getTitles: (value) {
                      return '${value.toInt()}';
                    },
                  ),
                ),
                gridData: FlGridData(
                    show: true,
                    checkToShowHorizontalLine: (value) {
                      return (value % chartLeftTitleInterval) == 0;
                    }),
              ),
            );
          },
        ));
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
