import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  const SavingAdd({Key? key, required this.onSubmit}) : super(key: key);

  final ValueChanged<String> onSubmit;

  @override
  State<SavingAdd> createState() => _SavingAddState();
}

class _SavingAddState extends State<SavingAdd> {
  String id = '';
  int _currentSlider = 1000;
  String autoID = '';

  TextEditingController savingController = TextEditingController();
  TextEditingController sliderController = TextEditingController();

  // var text = '';

  bool _submitted = false;

  void submit() {
    setState(() => _submitted = true);
    if (_errorText == null) {
      widget.onSubmit(savingController.value.text);
    }
  }

  @override
  void dispose() {
    savingController.dispose();
    super.dispose();
  }

  String? get _errorText {
    final text = savingController.value.text;

    if (text.isEmpty) {
      return "Can't be empty";
    }

    return null;
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
                Navigator.pop(
                  context,
                );
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 450,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(
                        Icons.android,
                        size: 60,
                        color: Colors.pink,
                      ),
                      Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Text(
                                    "Target",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              autovalidateMode: _submitted
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              controller: savingController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                // hintText: "Target",
                                // hintStyle:
                                //     const TextStyle(color: Colors.grey),
                                errorText: _errorText,
                              ),
                              onChanged: (text) => setState(() => text),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Text(
                                    "Amount of Saving",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: sliderController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 200,
                height: 35,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 15.0,
                    ),
                    onPressed: () {
                      // savingController.value.text.isNotEmpty ? _submit : null;
                      if (savingController.text.isEmpty) {
                        setState(() {
                          _submitted = true;
                        });
                      } else {
                        DataRepository()
                            .addSaving(Saving(
                              int.parse(sliderController.text),
                              date: DateTime.now(),
                              target: savingController.text,
                            ))
                            .then((value) => id = value.toString());
                        Navigator.pop(context, '/home');
                      }
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
