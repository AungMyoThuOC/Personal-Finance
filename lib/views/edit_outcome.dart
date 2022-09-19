import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:personal_financial/firebase_options.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/models/category.dart';
import 'package:personal_financial/models/income.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:animate_icons/animate_icons.dart';

class EditIncome extends StatefulWidget {
  EditIncome({Key? key, required this.income, required this.onSubmit})
      : super(key: key);
  final Income income;
  final ValueChanged<String> onSubmit;

  @override
  State<EditIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<EditIncome> {
  TextEditingController categoryController = TextEditingController();

  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  int iconNum = 0;
  String catName = '';
  AnimateIconController animatedController = AnimateIconController();
  bool checkDelete = false;
  bool choose = true;
  int indexOne = 0;
  int state = 0;
  int result = 0;
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
  bool main = false;

  List<dynamic> list = [];
  TabController? controller;
  void add() {
    DataRepository().addCategory(
        Category(name: categoryController.text, icon: indexOne, income: false));
  }

  // var text = '';

  bool submmitted = false;

  void submit() {
    setState(() => submmitted = true);
    if (_errorText == null) {
      widget.onSubmit(categoryController.value.text);
    }
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  String? get _errorText {
    final text = categoryController.value.text;

    if (text.isEmpty) {
      return "Can't be empty";
    }
    if (text.length > 7) {
      return "Too long";
    }
    return null;
  }

  @override
  void initState() {
    amountController.text = widget.income.amount.toString();
    super.initState();
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.only(top: 10.0),
              title: const Text("New Category"),
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(navBarItem[indexOne]),
                          SizedBox(
                            width: 200,
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              autovalidateMode: submmitted
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              controller: categoryController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Add Name",
                                hintStyle: const TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 224, 224, 224)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      width: 1,
                                      color:
                                          Color.fromARGB(255, 177, 177, 177)),
                                ),
                              ),
                              onChanged: (text) => setState(() => text),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 120,
                        child: GridView.count(
                          mainAxisSpacing: 19.0,
                          childAspectRatio: 1,
                          scrollDirection: Axis.horizontal,
                          addAutomaticKeepAlives: true,
                          crossAxisCount: 2,
                          children: List.generate(
                            navBarItem.length,
                            (index) => Center(
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blueAccent,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      indexOne = index;
                                    });
                                  },
                                  icon: Icon(
                                    navBarItem[index],
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          add();
                          Navigator.pop(context);
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
    Navigator.pop(context);
    amountController.clear();
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
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Edit Outcome",
                style: TextStyle(color: Colors.black),
              ),
            ],
          )
        ]),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Colors.transparent,
                height: 600,
                width: MediaQuery.of(context).size.width * 1,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon((main == false)
                                  ? navBarItem[
                                      int.parse(widget.income.category)]
                                  : navBarItem[result]),
                              Container(
                                width: 300,
                                child: TextField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Amount",
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          width: 1,
                                          color: Color.fromARGB(
                                              255, 224, 224, 224)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          width: 1,
                                          color: Color.fromARGB(
                                              255, 177, 177, 177)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Categories",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        AnimateIcons(
                                          startIcon: Icons.cancel,
                                          endIcon: Icons.cancel_outlined,
                                          size: 42.0,
                                          controller: animatedController,
                                          onStartIconPress: () {
                                            setState(() {
                                              checkDelete = true;
                                            });
                                            return true;
                                          },
                                          onEndIconPress: () {
                                            setState(() {
                                              checkDelete = false;
                                            });
                                            return true;
                                          },
                                          duration: const Duration(milliseconds: 500),
                                          clockwise: false,
                                        ),
                                        CircleAvatar(
                                          radius: 18,
                                          child: IconButton(
                                            splashRadius: 22,
                                            onPressed: () {
                                              openDialog();
                                            },
                                            icon: const Icon(Icons.add),
                                            iconSize: 18,
                                          ),
                                        ),
                                      ],
                                    )
                                  ]),
                              const SizedBox(
                                height: 35,
                              ),
                              Container(
                                width: 400,
                                height: 200,
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: DataRepository().getCategoryOut(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return LinearProgressIndicator();

                                      return GridView.count(
                                          scrollDirection: Axis.horizontal,
                                          addAutomaticKeepAlives: true,
                                          shrinkWrap: true,
                                          physics: const BouncingScrollPhysics(
                                              parent:
                                                  AlwaysScrollableScrollPhysics()),
                                          crossAxisCount: 2,
                                          children: snapshot.data!.docs
                                              .map(
                                                (e) => StreamBuilder<
                                                        QuerySnapshot>(
                                                    stream: DataRepository()
                                                        .getOut(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const CircularProgressIndicator();
                                                      }
                                                      var ds =
                                                          snapshot.data!.docs;

                                                      List sum = [];
                                                      for (int i = 0;
                                                          i < ds.length;
                                                          i++)
                                                        sum.add(
                                                            ds[i]['catName']);

                                                      return MyCategory(
                                                        delete: checkDelete,
                                                        onClicked:
                                                            (state, name) {
                                                          setState(() {
                                                            result = state;
                                                            catName = name;
                                                          });
                                                        },
                                                        category: Category
                                                            .fromSnapshot(e),
                                                        deleteClick: (sum == [])
                                                            ? (autoID) {
                                                                DataRepository()
                                                                    .deleteCategory(
                                                                        autoID);
                                                              }
                                                            : (autoID) {
                                                                showTopSnackBar(
                                                                  context,
                                                                  const CustomSnackBar
                                                                      .error(
                                                                    message:
                                                                        "This category used in Outcome",
                                                                  ),
                                                                );
                                                              },
                                                      );
                                                    }),
                                              )
                                              .toList());
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ),
            Container(
              width: 200,
              height: 40,
              child: StreamBuilder<QuerySnapshot>(
                  stream: DataRepository().getIn(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    var ds = snapshot.data!.docs;

                    double sumOne = 0.0;
                    for (int i = 0; i < ds.length; i++)
                      sumOne += (ds[i]['amount']).toDouble();

                    return StreamBuilder<QuerySnapshot>(
                        stream: DataRepository().getOut(),
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
                              stream: DataRepository().getMain(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }
                                var ds = snapshot.data!.docs;

                                double sumTwo = 0.0;
                                for (int i = 0; i < ds.length; i++)
                                  sumTwo += (ds[i]['amount']).toDouble();
                                return StreamBuilder<QuerySnapshot>(
                                    stream: DataRepository().getmain(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      var ds = snapshot.data!.docs;

                                      double totRemain = 0.0;
                                      for (int i = 0; i < ds.length; i++)
                                        totRemain +=
                                            (ds[i]['amount']).toDouble();
                                      print(sum);
                                      return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            elevation: 15.0,
                                          ),
                                          onPressed: (sumOne == 0)
                                              ? () {
                                                  showTopSnackBar(
                                                    context,
                                                    CustomSnackBar.error(
                                                      message:
                                                          "Your income left  ${sumOne - (sum + totRemain)}",
                                                    ),
                                                  );
                                                }
                                              : () {
                                                  if (int.parse(amountController
                                                          .text) >
                                                      (sumOne -
                                                          (sum + totRemain))) {
                                                    showTopSnackBar(
                                                      context,
                                                      CustomSnackBar.error(
                                                        message:
                                                            "Your income left  ${sumOne - (sum + totRemain)}",
                                                      ),
                                                    );
                                                  } else {
                                                    DataRepository().addIncome(
                                                        Income(
                                                            int.parse(
                                                                amountController
                                                                    .text),
                                                            date:
                                                                DateTime.now(),
                                                            category: state
                                                                .toString(),
                                                            income: false,
                                                            catName: catName));
                                                    Navigator.popAndPushNamed(
                                                        context, '/home');
                                                  }
                                                },
                                          child: const Text(
                                            'Save',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white),
                                          ));
                                    });
                              });
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyCategory extends StatefulWidget {
  MyCategory(
      {Key? key,
      required this.category,
      required this.onClicked,
      required this.delete,
      required this.deleteClick})
      : super(key: key);
  final Category category;
  final Function onClicked;
  final Function deleteClick;
  bool delete = false;
  @override
  State<MyCategory> createState() => _MyCategoryState();
}

class _MyCategoryState extends State<MyCategory> {
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

  set categoryController(icon) {
    icon = widget.category.icon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            child: IconButton(
              onPressed: (widget.delete == false)
                  ? () {
                      widget.onClicked(
                          widget.category.icon, widget.category.name);
                    }
                  : () {
                      widget.deleteClick(widget.category.autoID);
                    },
              icon: (widget.delete == false)
                  ? Icon(navBarItem[widget.category.icon])
                  : const Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.category.name,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
