import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:personal_financial/data_repository.dart';
import 'saving_dash.dart';
import '/models/remaning_saving.dart';
import '/models/saving.dart';
import 'dart:math';
import 'package:personal_financial/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavingAdd extends StatefulWidget {
  SavingAdd({Key? key}) : super(key: key);

  @override
  State<SavingAdd> createState() => _SavingAddState();
}

class _SavingAddState extends State<SavingAdd> {
  int _currentSlider = 1000;
  String id = '';

  TextEditingController savingController = TextEditingController();
  TextEditingController sliderController = TextEditingController();

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
              )),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.android_rounded,
                  color: Colors.pink,
                  size: 30,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: savingController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Target",
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      "Amount of Saving",
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
                        hintText: "1000",
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
              divisions: 20,
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
            Container(
              width: 200,
              height: 35,
              child: ElevatedButton(
                  onPressed: () {
                    if (savingController.text != null) {
                      DataRepository().addSaving(Saving(
                        _currentSlider,
                        date: DateTime.now(),
                        vaccinations: [],
                        target: savingController.text,
                      ));
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
