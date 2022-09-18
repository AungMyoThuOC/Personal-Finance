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

class AddIncome extends StatefulWidget {
  AddIncome({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  final ValueChanged<String> onSubmit;

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  TextEditingController categoryController = TextEditingController();

  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
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

  List<dynamic> list = [];
  TabController? controller;
  void add() {
    DataRepository()
        .addCategory(Category(name: categoryController.text, icon: indexOne));
  }

  var text = '';

  bool _submitted = false;

  void _submit() {
    setState(() => _submitted = true);
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
      return "can't be empty";
    }
    if (text.length > 7) {
      return "Too long";
    }
    return null;
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
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              autovalidateMode: _submitted
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              controller: categoryController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Add Name",
                                hintStyle: const TextStyle(color: Colors.grey),
                                errorText: _errorText,
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
                          Navigator.pop(context, '/home');
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
    Navigator.pop(context, '/home');
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
                        Icon(navBarItem[result]),
                        Container(
                          width: 300,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: amountController,
                            style: const TextStyle(color: Colors.black),
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
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Categories",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                                                result = state;
                                                catName = name;
                                              });
                                            },
                                            category: Category.fromSnapshot(e)))
                                        .toList());
                              }),
                        ),
                        const SizedBox(
                          height: 30,
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
                                  DataRepository().addIncome(
                                    Income(int.parse(amountController.text),
                                        date: DateTime.now(),
                                        category: state.toString(),
                                        income: true,
                                        catName: catName),
                                  );
                                  Navigator.popAndPushNamed(context, '/home');
                                }
                                // amountController.value.text.isNotEmpty
                                //   ? _submit
                                //   : null;
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                ]),
          ),
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
