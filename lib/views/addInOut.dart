import 'package:flutter/material.dart';
import 'package:personal_financial/firebase_options.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/models/income.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddInOut extends StatefulWidget {
  const AddInOut({Key? key}) : super(key: key);

  @override
  State<AddInOut> createState() => _AddInOutState();
}

class _AddInOutState extends State<AddInOut> {
  bool choose = true;
  bool newCategory = false;

  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
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
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ))
        ]),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(primary: Colors.white),
                      onPressed: (choose == false)
                          ? () {
                              setState(() {
                                choose = true;
                              });
                            }
                          : null,
                      child: Text(
                        'Income',
                        style: (choose == true)
                            ? const TextStyle(color: Colors.black, fontSize: 18)
                            : const TextStyle(color: Colors.grey, fontSize: 18),
                      )),
                  TextButton(
                      style: TextButton.styleFrom(primary: Colors.white),
                      onPressed: (choose == true)
                          ? () {
                              setState(() {
                                choose = false;
                              });
                            }
                          : null,
                      child: Text(
                        'Outcome',
                        style: (choose == false)
                            ? const TextStyle(color: Colors.black, fontSize: 18)
                            : const TextStyle(color: Colors.grey, fontSize: 18),
                      ))
                ],
              ),
              Container(
                width: (choose == true)
                    ? MediaQuery.of(context).size.width * 0.63
                    : MediaQuery.of(context).size.width * 0.58,
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  alignment: (choose == true)
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.19,
                        height: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
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
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
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
                              Icons.mail,
                              size: 30,
                            ),
                            SizedBox(
                              width: 300,
                              child: TextField(
                                controller: categoryController,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: "New Category",
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
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
                      Container(
                        width: 200,
                        height: 35,
                        child: ElevatedButton(
                            onPressed: () {
                              if (amountController.text != null &&
                                  categoryController.text != null) {
                                final newIncome = Income(
                                    int.parse(amountController.text),
                                    date: DateTime.now(),
                                    category: categoryController.text);
                                DataRepository().addIncome(newIncome);

                                print(newIncome);
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
      ),
    );
  }
}
