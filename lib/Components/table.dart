import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/models/income.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_financial/models/saving.dart';

class TableInOutCome extends StatefulWidget {
  const TableInOutCome({Key? key}) : super(key: key);

  @override
  State<TableInOutCome> createState() => _TableInOutComeState();
}

class _TableInOutComeState extends State<TableInOutCome> {
  double sum = 0;
  double total = 0;
  final DataRepository repository = DataRepository();

  void getIncomeSum() {
    FirebaseFirestore.instance
        .collection('User')
        .doc('admin@gmail.com')
        .collection('Income')
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

  @override
  void initState() {
    getIncomeSum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: StreamBuilder<QuerySnapshot>(
              stream: repository.getIncome(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                var ds = snapshot.data!.docs;
                double sum = 0.0;
                for (int i = 0; i < ds.length; i++)
                  sum += (ds[i]['amount']).toDouble();

                return Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Total is : $sum ",
                    ),
                  ),
                  const Text(
                    " ",
                  ),
                ]);
              }),
        ),
        Table(defaultColumnWidth: const FixedColumnWidth(130.0), children: [
          TableRow(children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Text(
                'Income',
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                '${sum}',
                textAlign: TextAlign.end,
              ),
            ),
          ]),
          const TableRow(children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Saving',
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                '1000',
                textAlign: TextAlign.end,
              ),
            )
          ]),
          const TableRow(children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Outcome',
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                '1000',
                textAlign: TextAlign.end,
              ),
            )
          ])
        ]),
      ],
    );
  }
}
