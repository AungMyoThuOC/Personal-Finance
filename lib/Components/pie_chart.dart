import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PieChart extends StatefulWidget {
  PieChart({Key? key}) : super(key: key);

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  final DataRepository repository = DataRepository();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: repository.getIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          var ds = snapshot.data!.docs;

          double total = 0.0;
          for (int i = 0; i < ds.length; i++)
            total += (ds[i]['amount']).toDouble();

          return StreamBuilder<QuerySnapshot>(
              stream: repository.getOut(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                var ds = snapshot.data!.docs;

                double totalOut = 0.0;
                for (int i = 0; i < ds.length; i++)
                  totalOut += (ds[i]['amount']).toDouble();
                return StreamBuilder<QuerySnapshot>(
                    stream: repository.getMain(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      var ds = snapshot.data!.docs;

                      double sumTwo = 0.0;
                      for (int i = 0; i < ds.length; i++)
                        sumTwo += (ds[i]['amount']).toDouble();
                      return StreamBuilder<QuerySnapshot>(
                          stream: repository.getmain(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            var ds = snapshot.data!.docs;

                            double totalSave = 0.0;
                            for (int i = 0; i < ds.length; i++)
                              totalSave += (ds[i]['amount']).toDouble();

                            return Container(
                                child: SfCircularChart(
                                    legend: Legend(isVisible: true),
                                    series: <CircularSeries>[
                                  PieSeries<ChartData, String>(
                                    legendIconType: LegendIconType.rectangle,
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                    ),
                                    dataSource: [
                                      ChartData(
                                          'Income',
                                          (total == 0)
                                              ? 1
                                              : (totalSave == 0)
                                                  ? (((total - totalOut) *
                                                          100) /
                                                      total)
                                                  : (((total -
                                                                  (totalOut +
                                                                      totalSave)) *
                                                              100) /
                                                          total) /
                                                      10,
                                          '${(total == 0) ? 0 : (totalSave == 0) ? (((total - totalOut) * 100) / total).toStringAsFixed(1) : (((total - (totalOut + totalSave)) * 100) / total).toStringAsFixed(1)}%'),
                                      ChartData(
                                          'Outcome',
                                          (total == 0)
                                              ? 1
                                              : (((totalOut == 0)
                                                      ? 1
                                                      : ((totalOut / total) *
                                                          100))) /
                                                  10,
                                          '${((total == 0) ? 0 : (totalOut == 0 ? 0 : ((totalOut / total) * 100)).toStringAsFixed(1))}%'),
                                      ChartData(
                                          'Saving',
                                          (total == 0)
                                              ? 1
                                              : (((totalSave == 0)
                                                      ? 0
                                                      : ((totalSave / total) *
                                                          100))) /
                                                  10,
                                          '${((total == 0) ? 0 : (totalSave == 0 ? 0 : ((totalSave / total) * 100)).toStringAsFixed(1))}%'),
                                    ],
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    dataLabelMapper: (ChartData data, _) =>
                                        data.size,
                                  ),
                                ]));
                          });
                    });
              });
        });
  }
}

class ChartData {
  final String x;
  final double y;
  final String size;
  ChartData(this.x, this.y, this.size);
}
