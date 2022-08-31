import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChart extends StatelessWidget {
  PieChart({Key? key}) : super(key: key);

  final List<ChartData> chartData = [
    ChartData('Income', 80, '80%'),
    ChartData('Outcome', 10, '10%'),
    ChartData('Saving', 10, '10%'),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SfCircularChart(
            legend: Legend(isVisible: true),
            series: <CircularSeries>[
          PieSeries<ChartData, String>(
            legendIconType: LegendIconType.rectangle,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelMapper: (ChartData data, _) => data.size,
          ),
        ]));
  }
}

class ChartData {
  final String x;
  final double y;
  final String size;
  ChartData(this.x, this.y, this.size);
}
