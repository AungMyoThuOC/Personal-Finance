import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// ignore: must_be_immutable
class SavingDetails extends StatefulWidget {
  SavingDetails({Key? key, required this.saving, required this.onSubmit})
      : super(key: key);
  Saving? saving;
  final ValueChanged<String> onSubmit;
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
  TextEditingController savingController = TextEditingController();
  TextEditingController sliderController = TextEditingController();
  double sum = 0;
  double sumOut = 0;
  double totalOut = 0;
  double total = 0;
  double max = 0;

  double resultIn = 0;
  double value = 0;
  bool validate = false;
  double resultOut = 0;

  final DataRepository repository = DataRepository();

  TextEditingController amountController = TextEditingController();

  // var num = '';

  bool submmitted = false;

  void submit() {
    setState(() => submmitted = true);
    if (_errorText == null) {
      widget.onSubmit(amountController.value.text);
    }
  }

  double sumRemain = 0;
  double totRemainOne = 0;
  Future<void> getCollectionData() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance
            .collectionGroup('Remaining')
            .get()
            .then((value) {
          value.docs.forEach((result) {
            sumRemain = sumRemain + result.data()['amount'];
            print(sumRemain);
          });
          setState(() {
            totRemainOne = sumRemain;
          });
        });
      });
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  String? get _errorText {
    final text = amountController.value.text;

    if (text.isEmpty) {
      return "Can't be empty";
    }
    return null;
  }

  @override
  void initState() {
    getCollectionData();
    super.initState();
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: ((context, setState) {
            return StreamBuilder<QuerySnapshot>(
                stream:
                    repository.getRemaining(widget.saving!.autoID.toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  var ds = snapshot.data!.docs;
                  double sum = 0.0;
                  for (int i = 0; i < ds.length; i++)
                    sum += (ds[i]['amount']).toDouble();
                  return AlertDialog(
                    contentPadding: const EdgeInsets.only(top: 10.0),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Text(
                                      "Amount",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: TextFormField(
                                autovalidateMode: submmitted
                                    ? AutovalidateMode.onUserInteraction
                                    : AutovalidateMode.disabled,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: sliderController,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: repository.getIn(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  var ds = snapshot.data!.docs;

                                  double sumOne = 0.0;
                                  for (int i = 0; i < ds.length; i++)
                                    sumOne += (ds[i]['amount']).toDouble();

                                  return StreamBuilder<QuerySnapshot>(
                                      stream: repository.getOut(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }
                                        var ds = snapshot.data!.docs;

                                        double sum = 0.0;
                                        for (int i = 0; i < ds.length; i++)
                                          sum += (ds[i]['amount']).toDouble();
                                        return StreamBuilder<QuerySnapshot>(
                                            stream: repository.getMain(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              }
                                              var ds = snapshot.data!.docs;

                                              double sumTwo = 0.0;
                                              for (int i = 0;
                                                  i < ds.length;
                                                  i++)
                                                sumTwo += (ds[i]['amount'])
                                                    .toDouble();
                                              return StreamBuilder<
                                                      QuerySnapshot>(
                                                  stream:
                                                      repository.getRemaining(
                                                          widget.saving!.autoID
                                                              .toString()),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    }
                                                    var ds =
                                                        snapshot.data!.docs;

                                                    double totRemain = 0.0;
                                                    for (int i = 0;
                                                        i < ds.length;
                                                        i++)
                                                      totRemain += (ds[i]
                                                              ['amount'])
                                                          .toDouble();

                                                    return InkWell(
                                                      onTap: () {
                                                        if (int.parse(
                                                                sliderController
                                                                    .text) >
                                                            (sumOne -
                                                                (sum +
                                                                    totRemainOne))) {
                                                          showTopSnackBar(
                                                            context,
                                                            CustomSnackBar
                                                                .error(
                                                              message:
                                                                  "Your income left  ${sumOne - (sum + totRemainOne)}",
                                                            ),
                                                          );
                                                        } else {
                                                          if (int.parse(
                                                                  sliderController
                                                                      .text) >
                                                              (widget.saving!
                                                                  .amount)) {
                                                            showTopSnackBar(
                                                              context,
                                                              CustomSnackBar
                                                                  .error(
                                                                message:
                                                                    "Your goal is to reach ${widget.saving!.amount}",
                                                              ),
                                                            );
                                                          } else {
                                                            if (int.parse(
                                                                    sliderController
                                                                        .text) >
                                                                (widget.saving!
                                                                        .amount -
                                                                    totRemain)) {
                                                              showTopSnackBar(
                                                                context,
                                                                CustomSnackBar
                                                                    .error(
                                                                  message:
                                                                      "Your goal is to reach ${widget.saving!.amount}",
                                                                ),
                                                              );
                                                            } else {
                                                              Navigator.of(context).pop(
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          SavingDetails(
                                                                            saving:
                                                                                widget.saving,
                                                                            onSubmit:
                                                                                (String value) {},
                                                                          )));
                                                              DataRepository()
                                                                  .updateRemaining(
                                                                      widget
                                                                          .saving!
                                                                          .autoID
                                                                          .toString(),
                                                                      Remaining(
                                                                        int.parse(
                                                                            sliderController.text),
                                                                        date: DateTime
                                                                            .now(),
                                                                      ));
                                                              amountController
                                                                  .clear();
                                                              if (totRemain ==
                                                                  widget.saving!
                                                                      .amount) {
                                                                showTopSnackBar(
                                                                  context,
                                                                  const CustomSnackBar
                                                                      .success(
                                                                    message:
                                                                        "Congratulations",
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 15.0,
                                                                bottom: 15.0),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Colors.blueAccent,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          32.0),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          32.0)),
                                                        ),
                                                        child: const Text(
                                                          "Save",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            });
                                      });
                                }),
                          ],
                        )),
                  );
                });
          })));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: StreamBuilder<QuerySnapshot>(
            stream: repository.getIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              var ds = snapshot.data!.docs;

              double sum = 0.0;
              for (int i = 0; i < ds.length; i++)
                sum += (ds[i]['amount']).toDouble();
              print(sum);
              return StreamBuilder<QuerySnapshot>(
                  stream: repository.getMain(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    var ds = snapshot.data!.docs;

                    double sumTwo = 0.0;
                    for (int i = 0; i < ds.length; i++)
                      sumTwo += (ds[i]['amount']).toDouble();
                    return StreamBuilder<QuerySnapshot>(
                        stream: repository
                            .getRemaining(widget.saving!.autoID.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          var ds = snapshot.data!.docs;

                          double totRemain = 0.0;
                          for (int i = 0; i < ds.length; i++)
                            totRemain += (ds[i]['amount']).toDouble();

                          return SizedBox(
                            width: 45,
                            child: FloatingActionButton(
                                elevation: 0,
                                onPressed: (sum == 0)
                                    ? () {
                                        showTopSnackBar(
                                          context,
                                          const CustomSnackBar.error(
                                            message: "Please Add Income First",
                                          ),
                                        );
                                      }
                                    : (totRemain == widget.saving!.amount)
                                        ? () {
                                            showTopSnackBar(
                                              context,
                                              const CustomSnackBar.success(
                                                message:
                                                    "You already reach your goal",
                                              ),
                                            );
                                          }
                                        : () {
                                            openDialog();
                                          },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                )),
                          );
                        });
                  });
            }),
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
                          StreamBuilder<QuerySnapshot>(
                              stream: repository.getRemaining(
                                  widget.saving!.autoID.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                var ds = snapshot.data!.docs;

                                double sum = 0.0;
                                for (int i = 0; i < ds.length; i++)
                                  sum += (ds[i]['amount']).toDouble();

                                return CircularPercentIndicator(
                                  progressColor: Colors.greenAccent,
                                  radius: 60.0,
                                  lineWidth: 13.0,
                                  animation: true,
                                  percent: sum / widget.saving!.amount,
                                  center: StreamBuilder<QuerySnapshot>(
                                      stream: repository.getRemaining(
                                          widget.saving!.autoID.toString()),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
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
                                              return const CircularProgressIndicator();
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
                                );
                              }),
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
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: Text(
                              '${widget.saving!.amount}',
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontSize: 16),
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
                                    return const CircularProgressIndicator();
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
                height: MediaQuery.of(context).size.height * 0.32,
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
