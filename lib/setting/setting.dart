import 'package:flutter/material.dart';
import 'package:personal_financial/data_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_financial/homepage.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import 'logout_dialog.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<void> deleteIn() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Income')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  Future<void> deleteOut() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Outcome')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  Future<void> deleteSaving() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

  Future<void> deleteCategory() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Category')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }

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
            result.reference.delete();
          });
        });
      });
    });
  }

  bool tappedYes = false;

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
                    Navigator.pushNamed(context, '/security');
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
                                          Radius.circular(20.0))),
                                  content: Container(
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                            child: ConfirmationSlider(
                                          height: 50,
                                          onConfirmation: () {
                                            Navigator.of(context).pop(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyHomePage()));
                                            deleteIn();
                                            deleteOut();
                                            deleteSaving();
                                            deleteCategory();
                                            getCollectionData();
                                          },
                                        )),
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
              const SizedBox(
                height: 40,
              ),
              TextButton(
                  onPressed: () async {
                    final action = await AlertDialogs.yesCalcelDialog(
                        context, "Logout", "Are you sure ?");
                    if (action == DialogsAction.yes) {
                      setState(() => tappedYes = true);
                    } else {
                      setState(() => tappedYes = false);
                    }
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Logout",
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
