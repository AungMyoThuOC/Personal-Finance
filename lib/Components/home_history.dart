// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:personal_financial/models/income.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:personal_financial/data_repository.dart';
// import 'package:personal_financial/views/add_income.dart';
import 'package:personal_financial/views/edit_income.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:personal_financial/models/saving.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/views/edit_outcome.dart';
import 'dart:math';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HomeHistory extends StatefulWidget {
  HomeHistory({Key? key, required this.income}) : super(key: key);
  final Income income;

  @override
  State<HomeHistory> createState() => _HomeHistoryState();
}

class _HomeHistoryState extends State<HomeHistory> {
  List<IconData> navBarItem = [
    Icons.family_restroom,
    Icons.cast_for_education,
    Icons.home,
    Icons.car_crash,
    Icons.shop,
    Icons.phone,
    Icons.percent,
    Icons.laptop,
    Icons.handshake,
    Icons.book_online_outlined,
    Icons.face,
    Icons.camera_alt,
    Icons.cabin,
    Icons.tire_repair,
    Icons.local_taxi,
    Icons.food_bank,
    Icons.hotel_class,
    Icons.gamepad_sharp,
    Icons.abc,
    Icons.hail,
    Icons.wallet_giftcard,
    Icons.train,
    Icons.phone_android,
    Icons.icecream,
    Icons.star,
    Icons.monetization_on,
    Icons.ac_unit_sharp,
  ];
  double sumRemain = 0;
  double totRemain = 0;
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

  @override
  void initState() {
    getCollectionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: DataRepository().getIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          var ds = snapshot.data!.docs;

          double sumOne = 0.0;
          bool income = widget.income.income;
          for (int i = 0; i < ds.length; i++)
            sumOne += (ds[i]['amount']).toDouble();

          return StreamBuilder<QuerySnapshot>(
              stream: DataRepository().getOut(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                var ds = snapshot.data!.docs;

                double sum = 0.0;
                for (int i = 0; i < ds.length; i++)
                  sum += (ds[i]['amount']).toDouble();
                return StreamBuilder<QuerySnapshot>(
                    stream: DataRepository().getMain(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      var ds = snapshot.data!.docs;

                      double sumTwo = 0.0;
                      for (int i = 0; i < ds.length; i++)
                        sumTwo += (ds[i]['amount']).toDouble();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Slidable(
                          key: Key(widget.income.autoID.toString()),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () {
                              if (income == true) {
                                if ((sumOne - widget.income.amount) <
                                    (sum + totRemain)) {
                                  showTopSnackBar(
                                    context,
                                    const CustomSnackBar.error(
                                      message: "Your can't delete",
                                    ),
                                  );
                                } else {
                                  DataRepository().deleteIncome(
                                      widget.income.autoID.toString());
                                }
                              } else {
                                DataRepository().deleteIncome(
                                    widget.income.autoID.toString());
                              }
                            }),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  if (income == true) {
                                    if ((sumOne - widget.income.amount) <
                                        (sum + totRemain)) {
                                      showTopSnackBar(
                                        context,
                                        const CustomSnackBar.error(
                                          message: "Your can't delete",
                                        ),
                                      );
                                    } else {
                                      DataRepository().deleteIncome(
                                          widget.income.autoID.toString());
                                    }
                                  } else {
                                    DataRepository().deleteIncome(
                                        widget.income.autoID.toString());
                                  }
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          startActionPane: ActionPane(
                            motion: ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () {
                              if (income == true) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditIncome(
                                          income: widget.income,
                                          onSubmit: (String value) {},
                                        )));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditOutcome(
                                          income: widget.income,
                                          onSubmit: (String value) {},
                                        )));
                              }
                            }),
                            children: [
                              SlidableAction(
                                flex: 2,
                                onPressed: (mm) {
                                  if (income == true) {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => EditIncome(
                                                  income: widget.income,
                                                  onSubmit: (String value) {},
                                                )));
                                  } else {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => EditOutcome(
                                                  income: widget.income,
                                                  onSubmit: (String value) {},
                                                )));
                                  }
                                },
                                backgroundColor: Color(0xFF7BC043),
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 3),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            navBarItem[int.parse(
                                                widget.income.category)],
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${widget.income.catName}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 200,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            (widget.income.income == true)
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                        'Income',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                        'Outcome',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 22),
                                              child: Text(
                                                "${widget.income.amount}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              });
        });
  }
}
