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

class EditIncome extends StatefulWidget {
  EditIncome({Key? key, required this.income}) : super(key: key);
  final Income income;
  @override
  State<EditIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<EditIncome> {
  TextEditingController categoryController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  int iconNum = 0;
  String catName = '';
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
    DataRepository()
        .addCategory(Category(name: categoryController.text, icon: indexOne));
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
              contentPadding: EdgeInsets.only(top: 10.0),
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
                            child: TextField(
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
                "Edit Income",
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
                                  ]),
                              const SizedBox(
                                height: 35,
                              ),
                              Container(
                                width: 400,
                                height: 200,
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: DataRepository().getCategory(),
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
                                              .map((e) => MyCategory(
                                                  onClicked: (state, name) {
                                                    setState(() {
                                                      main = true;
                                                      result = state;
                                                      catName = name;
                                                      print(result);
                                                      print(main);
                                                      print(catName);
                                                    });
                                                  },
                                                  category:
                                                      Category.fromSnapshot(e)))
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
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 15.0,
                  ),
                  onPressed: () {
                    if (amountController.text != null &&
                        categoryController.text != null) {
                      DataRepository().updateIncome(
                          widget.income.autoID.toString(),
                          Income(int.parse(amountController.text),
                              date: DateTime.now(),
                              category: result.toString(),
                              income: true,
                              catName: catName));
                      Navigator.popAndPushNamed(context, '/home');
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class MyCategory extends StatefulWidget {
  MyCategory({Key? key, required this.category, required this.onClicked})
      : super(key: key);
  final Category category;
  final Function onClicked;

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
  bool isActive = false;

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
              onPressed: () {
                widget.onClicked(widget.category.icon, widget.category.name);
              },
              icon: Icon(navBarItem[widget.category.icon]),
            ),
          ),
          Text(
            widget.category.name,
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}
