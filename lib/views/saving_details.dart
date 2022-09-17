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
  int _currentSlider = 1000;
  AnimateIconController controller = AnimateIconController();
  bool visible = false;
  var opacity = 0.0;
  double remaining = 0;
  double tot = 0;
  double result = 0;
  TextEditingController savingController = TextEditingController();
  TextEditingController sliderController = TextEditingController();

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

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.only(top: 10.0),
              title: const Text("Add Remaining"),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              content: Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                "Amount",
                              ),
                            ),
                            Container(
                              width: 80,
                              child: TextFormField(
                                showCursor: true,
                                readOnly: true,
                                controller: sliderController,
                                style: const TextStyle(fontSize: 20),
                                decoration: const InputDecoration(
                                  hintText: "100",
                                  hintStyle: TextStyle(fontSize: 20),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Slider(
                        value: _currentSlider.toDouble(),
                        min: 1000,
                        max: 30000,
                        label: _currentSlider.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentSlider = value.toInt();
                            print(_currentSlider);

                            sliderController.text = _currentSlider.toString();
                          });
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                          DataRepository().updateRemaining(
                              widget.saving!.autoID.toString(),
                              Remaining(
                                _currentSlider,
                                date: DateTime.now(),
                              ));
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32.0),
                                bottomRight: Radius.circular(32.0)),
                          ),
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          })));
  void save() {
    Navigator.pop(
      context,
    );
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SizedBox(
          width: 45,
          child: FloatingActionButton(
              elevation: 0,
              onPressed: () {
                openDialog();
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
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
                          CircularPercentIndicator(
                            progressColor: Colors.greenAccent,
                            radius: 60.0,
                            lineWidth: 13.0,
                            animation: true,
                            percent:
                                (tot == 0) ? 0 : tot / widget.saving!.amount,
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
                                        sum += (ds[i]['amount']).toDouble();
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
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
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
                            child: StreamBuilder<QuerySnapshot>(
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
                                    sum += (ds[i]['amount']).toDouble();

                                  return Text(
                                    '${widget.saving!.amount - sum}',
                                    textAlign: TextAlign.end,
                                  );
                                }),
                          )
                        ]),
                      ]),
                    ),
                  ]),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                child: StreamBuilder<QuerySnapshot>(
                    stream: repository
                        .getRemaining(widget.saving!.autoID.toString()),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                        remaining: Remaining.fromSnapshot(data),
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
            ],
          ),
        ]));
  }
}
