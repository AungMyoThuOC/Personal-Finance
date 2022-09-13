import 'dart:html';

import 'package:personal_financial/models/remaning_saving.dart';
import './models/income.dart';
import 'dart:math';
import 'firebase_options.dart';
import './models/saving.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepository {
  CollectionReference ref = FirebaseFirestore.instance.collection('User');
  Future userData(String email) async {
    return await ref.doc(email).set({
      'email': email,
    });
  }

  Future updateUserData(String name) async {
    return await ref.doc(name).collection('Income').doc().set({
      'name': name,
    });
  }

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('User');

  Stream<QuerySnapshot> getAddStream() {
    return ref.doc('admin@gmail.com').collection('Income').snapshots();
  }

  Future<DocumentReference> addIncome(Income income) async {
    return await ref
        .doc('admin@gmail.com')
        .collection('Income')
        .add(income.toJson());
  }

  Stream<QuerySnapshot> getSavingStream() {
    return ref.doc('admin@gmail.com').collection('Saving').snapshots();
  }

  Future<DocumentReference> addSaving(Saving saving) async {
    return await ref
        .doc('admin@gmail.com')
        .collection('Saving')
        .add(saving.toJson());
  }

  Future updateRemaining(String id, Remaining remaining) async {
    return await ref
        .doc('admin@gmail.com')
        .collection('Saving')
        .doc(id)
        .collection("Remaining")
        .doc()
        .set({'amount': remaining.amount, 'date': remaining.date});
  }

  Future deleteSaving(String id) async {
    return await ref
        .doc('admin@gmail.com')
        .collection('Saving')
        .doc(id)
        .delete();
  }

  Stream<QuerySnapshot> getIncome() {
    return ref.doc('admin@gmail.com').collection('Income').snapshots();
  }
}
