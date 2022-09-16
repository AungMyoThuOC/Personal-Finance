// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:personal_financial/firebase_options.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:personal_financial/models/income.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({Key? key, required this.onSubmit})
      : super(
          key: key,
        );

  final ValueChanged<String> onSubmit;

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final numbers = List.generate(1, (index) => '$index');
  final contro = ScrollController();

  TextEditingController categoryController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  DateTime dateTime = DateTime(2022, 9, 13, 11, 06);

  bool choose = true;

  bool newCategory = false;

  TabController? controller;

  var _text = '';

  bool _submitted = false;

  void _submit() {
    setState(() => _submitted = true);
    if (_errorText == null) {
      widget.onSubmit(categoryController.value.text);
    }
  }

  int activeIndex = 0;

  @override
  void dispose() {
    categoryController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  String? get _errorText {
    final text = categoryController.value.text;

    if (text.isEmpty) {
      return "can't be empty";
    }
    if (text.length > 6) {
      return "Too long";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // datetime
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
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
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
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
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              autovalidateMode: _submitted
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              controller: categoryController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "New Category",
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
                              onChanged: (text) => setState(() => _text),
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(
                        height: 40,
                      ),
                    SizedBox(
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.date_range,
                          size: 30,
                        ),
                        SizedBox(
                            width: 300,
                            child: ElevatedButton(
                                onPressed: pickDateTime,
                                child: Text(
                                    '${dateTime.year}/${dateTime.month}/${dateTime.day} $hours:$minutes'))
                            // child: TextField(
                            //   controller: categoryController,
                            //   style: const TextStyle(color: Colors.black),
                            //   decoration: InputDecoration(
                            //     hintText: "DateTime",
                            //     hintStyle: const TextStyle(color: Colors.grey),
                            //     enabledBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //       borderSide: const BorderSide(
                            //           width: 1,
                            //           color: Color.fromARGB(255, 224, 224, 224)),
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //       borderSide: const BorderSide(
                            //           width: 1,
                            //           color: Color.fromARGB(255, 177, 177, 177)),
                            //     ),
                            //   ),
                            // ),
                            ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 200,
                      height: 35,
                      child: ElevatedButton(
                          onPressed: () {
                            categoryController.value.text.isNotEmpty
                                ? _submit
                                : null;
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
                    ),
                    // Container(
                    //   width: 200,
                    //   height: 200,
                    //   child: buildGridView(),
                    // )
                  ]),
            ),
          ),
        ),
      ],
    );
  }
  
  // DateTime
  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return; // pressed "CANCEL"

    TimeOfDay? time = await pickTime();
    if (time == null) return; // pressed "CANCEL"

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() => this.dateTime = dateTime);
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: dateTime.hour,
        minute: dateTime.minute,
      ));
}
