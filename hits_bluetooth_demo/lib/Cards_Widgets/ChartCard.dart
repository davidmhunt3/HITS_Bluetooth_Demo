import 'package:flutter/material.dart';
import 'package:hits_bluetooth_demo/constants.dart';
import 'package:hits_bluetooth_demo/Chart.dart';

class SeriesData {
  String title;
  List<double> series;
  Color color;

  SeriesData(
      {@required this.title, @required this.series, this.color = Colors.red});
}

class ChartCard extends StatelessWidget {
  String title;
  List<SeriesData> chartData;
  int numCharts;

  ChartCard({@required this.title, @required this.chartData}) {
    //Actual Initialization

    numCharts = chartData.length;
  }

  Widget generateLegend() {
    List<Widget> widgetList = [];
    for (int i = 0; i < numCharts; i++) {
      widgetList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 3.0,
            width: 15.0,
            color: chartData[i].color,
          ),
          SizedBox.fromSize(size: Size(5.0, 0)),
          Text(chartData[i].title),
        ],
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgetList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(kDeviceCardMargin, kDeviceCardMargin / 2,
          kDeviceCardMargin, kDeviceCardMargin / 2),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: kDeviceCardBackgroundColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      //constraints: BoxConstraints.expand(height: 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: kDeviceNameTextStyle,
          ),
          SizedBox.fromSize(
            size: Size(double.infinity, 30),
          ),
          Chart(chartData: chartData, numCharts: numCharts),
          SizedBox.fromSize(
            size: Size(double.infinity, 15),
          ),
          generateLegend(),
        ],
      ),
    );
  }
}
