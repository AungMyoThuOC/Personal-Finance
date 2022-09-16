import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:personal_financial/models/saving.dart';
import 'package:personal_financial/data_repository.dart';
import 'saving_details.dart';
import 'dart:math';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

class SavingList extends StatefulWidget {
  const SavingList({Key? key, required this.saving}) : super(key: key);
  final Saving saving;

  @override
  State<SavingList> createState() => _SavingListState();
}

class _SavingListState extends State<SavingList> {
  int _currentSlider = 1000;
  bool edit = false;
  TextEditingController savingController = TextEditingController();
  TextEditingController sliderController = TextEditingController();
  double sum = 0;
  double total = 0;
  double percent = 0;

  double tot = 0;
  final DataRepository repository = DataRepository();
  void getRemaining() {
    FirebaseFirestore.instance
        .collection('User')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .doc(widget.saving.autoID)
        .collection('Remaining')
        .get()
        .then(
      (str) {
        str.docs.forEach((result) {
          setState(() {
            tot = tot + result.data()['amount'];
          });
        });
      },
    );
  }

  @override
  void initState() {
    getRemaining();
    savingController.text = widget.saving.target;
    sliderController.text = widget.saving.amount.toString();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentSlider = widget.saving.amount;
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
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SavingDetails(
                            saving: widget.saving,
                          )));
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.android,
                                  size: 45,
                                  color: Colors.blueAccent,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        widget.saving.target,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: repository.getRemaining(
                                              widget.saving.autoID.toString()),
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
                                              '${sum}/${widget.saving.amount}',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PullDownButton(
                            backgroundColor: Colors.white,
                            itemBuilder: (context) => [
                              PullDownMenuItem(
                                title: 'Edit',
                                onTap: () {
                                  showTopModalSheet(
                                      context,
                                      StatefulBuilder(
                                        builder: (context, setState) => Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            height: 300,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      const Icon(
                                                        Icons.android_rounded,
                                                        color: Colors.pink,
                                                        size: 30,
                                                      ),
                                                      SizedBox(
                                                        width: 300,
                                                        child: TextField(
                                                          controller:
                                                              savingController,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                          decoration:
                                                              InputDecoration(
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide: const BorderSide(
                                                                  width: 1,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          224,
                                                                          224,
                                                                          224)),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide: const BorderSide(
                                                                  width: 1,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          177,
                                                                          177,
                                                                          177)),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: const [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 30),
                                                          child: Text(
                                                            "Amount of Saving",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 30),
                                                    child: TextField(
                                                      controller:
                                                          sliderController,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        width: 100,
                                                        height: 35,
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              if (savingController
                                                                      .text !=
                                                                  null) {
                                                                DataRepository()
                                                                    .updateSaving(
                                                                        widget
                                                                            .saving
                                                                            .autoID
                                                                            .toString(),
                                                                        Saving(
                                                                          _currentSlider,
                                                                          date:
                                                                              DateTime.now(),
                                                                          target:
                                                                              savingController.text,
                                                                        ));
                                                              }
                                                              Navigator.pop(
                                                                  context,
                                                                  '/home');
                                                            },
                                                            child: const Text(
                                                              'Update',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16),
                                                            )),
                                                      ),
                                                      Container(
                                                        width: 100,
                                                        height: 35,
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16),
                                                            )),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ));
                                },
                              ),
                              const PullDownMenuDivider(),
                              PullDownMenuItem(
                                title: 'Delete',
                                onTap: () => {
                                  DataRepository()
                                      .deleteSaving(widget.saving.autoID!)
                                },
                              ),
                            ],
                            position: PullDownMenuPosition.under,
                            buttonBuilder: (context, showMenu) => Container(
                              child: CupertinoButton(
                                onPressed: showMenu,
                                padding: EdgeInsets.zero,
                                child:
                                    const Icon(CupertinoIcons.ellipsis_circle),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LinearPercentIndicator(
                        animation: true,
                        lineHeight: 12,
                        animationDuration: 2000,
                        percent: (tot == 0) ? 0 : tot / widget.saving.amount,
                        barRadius: const Radius.circular(10),
                        center: StreamBuilder<QuerySnapshot>(
                            stream: repository
                                .getRemaining(widget.saving.autoID.toString()),
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
                                '${(sum / widget.saving.amount * 100).toStringAsFixed(2)}%',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 10),
                              );
                            }),
                        progressColor: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
