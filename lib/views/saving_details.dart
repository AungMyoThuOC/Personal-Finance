import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:personal_financial/Components/home_history.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/models/remaning_saving.dart';
import 'package:personal_financial/models/saving.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_financial/Components/remainig_history.dart';
import 'package:personal_financial/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavingDetails extends StatefulWidget {
  SavingDetails({Key? key, required this.saving}) : super(key: key);
  Saving? saving;
  @override
  State<SavingDetails> createState() => _SavingDetailsState();
}

class _SavingDetailsState extends State<SavingDetails> {
  bool check = true;
  AnimateIconController controller = AnimateIconController();
  bool visible = false;
  var opacity = 0.0;
  double remaining = 0;
  double tot = 0;
  double result = 0;

  final DataRepository repository = DataRepository();

  TextEditingController amountController = TextEditingController();
  void getRemaining() {
    FirebaseFirestore.instance
        .collection('User')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .doc(widget.saving!.autoID)
        .collection('Remaining')
        .get()
        .then(
      (StreamBuilder) {
        StreamBuilder.docs.forEach((result) {
          remaining = remaining + result.data()['amount'];
        });
        setState(() {
          tot = remaining;
          print(tot);
        });
      },
    );
  }

  @override
  void initState() {
    getRemaining();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/home');
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ))
          ]),
        ),
        body: Stack(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 30.0,
                        spreadRadius: 1,
                        offset: Offset(0.0, 3.0),
                      ),
                    ],
                  ),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          (check)
                              ? CircularPercentIndicator(
                                  radius: 60.0,
                                  lineWidth: 13.0,
                                  animation: true,
                                  percent: (tot == 0)
                                      ? 0
                                      : tot / widget.saving!.amount,
                                  center: StreamBuilder<QuerySnapshot>(
                                      stream: repository.getRemaining(
                                          widget.saving!.autoID.toString()),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        var ds = snapshot.data!.docs;

                                        double sum = 0.0;
                                        for (int i = 0; i < ds.length; i++) {
                                          sum += (ds[i]['amount']).toDouble();
                                        }
                                        return Text(
                                          '${(sum / widget.saving!.amount * 100).toStringAsFixed(2)}%',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }),
                                  footer: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                          stream: repository.getRemaining(
                                              widget.saving!.autoID.toString()),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }
                                            var ds = snapshot.data!.docs;
                                            double sum = 0.0;
                                            for (int i = 0; i < ds.length; i++)
                                              sum +=
                                                  (ds[i]['amount']).toDouble();
                                            return Text(
                                              '${sum}/${widget.saving!.amount}MMK',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.greenAccent,
                                )
                              : Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: LinearPercentIndicator(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    animation: true,
                                    lineHeight: 20.0,
                                    animationDuration: 2000,
                                    percent: (tot == 0)
                                        ? 0
                                        : tot / widget.saving!.amount,
                                    center: StreamBuilder<QuerySnapshot>(
                                        stream: repository.getRemaining(
                                            widget.saving!.autoID.toString()),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          }
                                          var ds = snapshot.data!.docs;

                                          double sum = 0.0;
                                          for (int i = 0; i < ds.length; i++) {
                                            sum += (ds[i]['amount']).toDouble();
                                          }
                                          return Text(
                                            '${(sum / widget.saving!.amount * 100).toStringAsFixed(2)}%',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          );
                                        }),
                                    barRadius: const Radius.circular(10),
                                    progressColor: Colors.greenAccent,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Table(children: [
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 15.0,
                            ),
                            child: Text(
                              'Target Name:',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              '${widget.saving!.target}',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              'Target Price:',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              '${widget.saving!.amount}',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ]),
                        TableRow(children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              'Remaining',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              '${widget.saving!.amount - tot}',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ]),
                      ]),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blueAccent,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                opacity = opacity == 0.0 ? 1 : 0;
                              });
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ))
                  ]),
                ),
              ),
              NotificationListener(
                onNotification: (ScrollNotification notify) {
                  setState(() {
                    if (notify.metrics.pixels > 30) {
                      check = false;
                    } else {
                      check = true;
                    }
                  });
                  return false;
                },
                child: Container(
                  height: 220,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: repository
                          .getRemaining(widget.saving!.autoID.toString()),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return LinearProgressIndicator();

                        // return _buildList(context, snapshot.data?.docs ?? []);
                        return Column(
                          children: [
                            Expanded(
                              child: ListView(
                                addAutomaticKeepAlives: true,
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                shrinkWrap: true,
                                children: snapshot.data!.docs
                                    .map((data) => HistRemain(
                                          remaining:
                                              Remaining.fromSnapshot(data),
                                          autoID:
                                              widget.saving!.autoID.toString(),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
            ],
          ),
          Positioned(
              left: 80,
              bottom: 280,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: opacity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 3),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.black,
                    child: Column(
                      children: [
                        TextField(
                          controller: amountController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Amount",
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 224, 224, 224)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 177, 177, 177)),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  DataRepository().updateRemaining(
                                      widget.saving!.autoID.toString(),
                                      Remaining(
                                        int.parse(amountController.text),
                                        date: DateTime.now(),
                                      ));
                                },
                                child: const Text('Save'))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ]));
  }
}
