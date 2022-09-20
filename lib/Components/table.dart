import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/models/income.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_financial/models/remaning_saving.dart';
import 'package:personal_financial/models/saving.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TableInOutCome extends StatefulWidget {
  const TableInOutCome({Key? key}) : super(key: key);

  @override
  State<TableInOutCome> createState() => _TableInOutComeState();
}

class _TableInOutComeState extends State<TableInOutCome> {
  double sum = 0;
  double sumOut = 0;
  double total = 0;
  double totalOut = 0;
  double saving = 0;
  double sumRemain = 0;
  double totRemain = 0;
  double tot = 0;
  DocumentReference? reference;
  final DataRepository repository = DataRepository();

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

  Future<void> getCollectionData() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance
            .collection('User')
            .doc('${FirebaseAuth.instance.currentUser!.email}')
            .collection('Saving')
            .doc(doc.id)
            .collection("Remaining")
            .get()
            .then((QuerySnapshot<Map> querySnapshot) {
          querySnapshot.docs.forEach((result) {
            sumRemain = sumRemain + result.data()['amount'];
            print(sumRemain);
          });
          setState(() {
            totRemain = sumRemain;
          });
        });
      });
    });
  }

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

  void getRemaining() {
    FirebaseFirestore.instance
        .collection('User')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .get()
        .then(
      (StreamBuilder) {
        StreamBuilder.docs.forEach((result) {
          saving = saving + result.data()['amount'];
        });
        setState(() {
          tot = saving;
          print(tot);
        });
      },
    );
  }

  @override
  void initState() {
    getCollectionData();
    getRemaining();
    getIncomeSum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          child: StreamBuilder<QuerySnapshot>(
              stream: repository.getIncome(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                var ds = snapshot.data!.docs;
                double sum = 0.0;
                for (int i = 0; i < ds.length; i++)
                  sum += (ds[i]['amount']).toDouble();
                return Text('');
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
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: repository.getIn(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    var ds = snapshot.data!.docs;
                    double sum = 0.0;
                    for (int i = 0; i < ds.length; i++)
                      sum += (ds[i]['amount']).toDouble();
                    return Text(
                      '${sum}',
                      textAlign: TextAlign.end,
                    );
                  }),
            ),
          ]),
          TableRow(children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Saving',
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  '${totRemain}',
                  textAlign: TextAlign.end,
                ))
          ]),
          TableRow(children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Outcome',
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: repository.getOut(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    var ds = snapshot.data!.docs;
                    double sum = 0.0;
                    for (int i = 0; i < ds.length; i++)
                      sum += (ds[i]['amount']).toDouble();

                    return Text(
                      '${sum}',
                      textAlign: TextAlign.end,
                    );
                  }),
            ),
          ]),
        ]),
      ],
    );
  }
}
