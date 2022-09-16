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
  double sum = 0;
  double sumOut = 0;
  double totalOut = 0;
  double total = 0;
  double sumSave = 0;
  double totalSave = 0;
  double resultIn = 0;
  double resultOut = 0;
  double saving = 0;
  double tot = 0;
  final DataRepository repository = DataRepository();

  void getOutcomeSum() {
    FirebaseFirestore.instance
        .collection('User')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Income')
        .where('income', isEqualTo: false)
        .get()
        .then(
      (StreamBuilder) {
        StreamBuilder.docs.forEach((result) {
          sumOut = sumOut + result.data()['amount'];
        });
        setState(() {
          totalOut = sumOut;
        });
      },
    );
  }

  void getIncomeSum() {
    FirebaseFirestore.instance
        .collection('User')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Income')
        .where('income', isEqualTo: true)
        .get()
        .then(
      (StreamBuilder) {
        StreamBuilder.docs.forEach((result) {
          sum = sum + result.data()['amount'];
        });
        setState(() {
          total = sum;
        });
      },
    );
  }

  Future<void> getSavingSum() async {
    await FirebaseFirestore.instance
        .collectionGroup('Remaining')
        .get()
        .then((StreamBuilder) {
      StreamBuilder.docs.forEach((result) {
        sumSave = sumSave + result.data()['amount'];
        print(result.data()['amount']);
      });
      setState(() {
        totalSave = sumSave;
        print("?????$totalSave");
      });
    });
  }

  @override
  void initState() {
    getIncomeSum();
    getOutcomeSum();
    getSavingSum();
    getPercent();
    super.initState();
  }

  @override
  void getPercent() {
    setState(() {
      resultOut == totalOut;
      print(resultOut);
    });
  }

  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(
          'Income',
          (total == 0) ? 1 : (((total - totalOut) * 100) / total) / 10,
          '${(total == 0) ? 0 : (totalSave == 0) ? (((total - totalOut) * 100) / total) : (((total - (totalOut + totalSave)) * 100) / total).toStringAsFixed(1)}%'),
      ChartData(
          'Outcome',
          (total == 0)
              ? 1
              : (((totalOut == 0) ? 0 : ((totalOut / total) * 100))) / 10,
          '${((total == 0) ? 0 : (totalOut == 0 ? 0 : ((totalOut / total) * 100)).toStringAsFixed(1))}%'),
      ChartData(
          'Saving',
          (total == 0)
              ? 1
              : (((totalSave == 0) ? 0 : ((totalSave / total) * 100))) / 10,
          '${((total == 0) ? 0 : (totalSave == 0 ? 0 : ((totalSave / total) * 100)).toStringAsFixed(1))}%'),
    ];
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
