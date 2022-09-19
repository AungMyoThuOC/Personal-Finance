import 'package:flutter/material.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context, '/home');
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            const SizedBox(
              width: 40,
            ),
            const Text(
              "Setting",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
          ],
        ),
        //  backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/color');
                  },
                  child: Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Icon(Icons.color_lens),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Colors",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            // color: Colors.black
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                  onPressed: () {
<<<<<<< HEAD
                     Navigator.pushNamed(context, '/security');
=======
                    Navigator.pushNamed(context, '/security');
>>>>>>> c90671f9305f500ff32a2abc3f85aa1d6814a607
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.security),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Security",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          // color: Colors.black,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            StatefulBuilder(builder: ((context, setState) {
                              return AlertDialog(
                                  contentPadding:
                                      const EdgeInsets.only(top: 10.0),
                                  title: const Text(
                                      "Do you wanna delete all of your records?"),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32.0))),
                                  content: Container(
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context, '/home');
                                                  },
                                                  child: const Text(
                                                    "Reset",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ])));
                            })));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.restart_alt),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Reset Data",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
