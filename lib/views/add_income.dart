import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:personal_financial/firebase_options.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/models/income.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddIncome extends StatefulWidget {
  AddIncome({Key? key}) : super(key: key);

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  TextEditingController categoryController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  bool choose = true;

  bool newCategory = false;

  TabController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            color: Colors.transparent,
            height: 600,
            width: MediaQuery.of(context).size.width * 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.man,
                            size: 35,
                          ),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: amountController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Amount",
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(children: const [
                            Text(
                              "Categories",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ]),
                          const SizedBox(
                            height: 35,
                          ),
                          Row(
                            children: [
                              Column(
                                children: const [
                                  CircleAvatar(
                                    radius: 25,
                                    child: Icon(
                                      Icons.museum,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Museum",
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                      radius: 25,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              newCategory = !newCategory;
                                            });
                                          },
                                          icon: const Icon(Icons.add))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    "Create",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    if (newCategory == true)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.email_rounded,
                            size: 30,
                          ),
                          SizedBox(
                            width: 300,
                            child: TextField(
                              controller: categoryController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "New Category",
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
                      )
                    else
                      const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.date_range,
                          size: 30,
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: categoryController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "DateTime",
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
                    Container(
                      width: 200,
                      height: 35,
                      child: ElevatedButton(
                          onPressed: () {
                            if (amountController.text != null &&
                                categoryController.text != null) {
                              DataRepository().addIncome(Income(
                                  int.parse(amountController.text),
                                  date: DateTime.now(),
                                  category: categoryController.text));
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                    )
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}
