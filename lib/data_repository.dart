import 'package:personal_financial/models/remain_all.dart';
import 'package:personal_financial/models/remaning_saving.dart';
import './models/income.dart';
import 'dart:math';
import 'firebase_options.dart';
import './models/saving.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/category.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataRepository {
  CollectionReference ref = FirebaseFirestore.instance.collection('User');
  CollectionReference reference =
      FirebaseFirestore.instance.collection('Category');
  Future userData(String email) async {
    return await ref.doc(email).set({
      'email': FirebaseAuth.instance.currentUser!.email,
    });
  }

  Future updateUserData(String name) async {
    return await ref
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('Income')
        .doc()
        .set({'name': FirebaseAuth.instance.currentUser!.email});
  }

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('User');

  Stream<QuerySnapshot> getAddStream() {
    return ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Income')
        .snapshots();
  }

  Stream<QuerySnapshot> getRemainAll() {
    return ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('AllRemaining')
        .snapshots();
  }

  Future<DocumentReference> addIncome(Income income) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Income')
        .add(income.toJson());
  }

  Stream<QuerySnapshot> getSavingStream() {
    return ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .snapshots();
  }

  Future<DocumentReference> addSaving(Saving saving) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .add(saving.toJson());
  }

  Future<DocumentReference> addRemainAll(AllRemain remainAll) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('AllRemaining')
        .add(remainAll.toJson());
  }

  Future<DocumentReference> addCategory(Category category) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Category')
        .add(category.toJson());
  }

  Future updateRemaining(String id, Remaining remaining) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .doc(id)
        .collection("Remaining")
        .doc()
        .set({
      'amount': remaining.amount,
      'date': remaining.date,
    });
  }

  Future updateSaving(String id, Saving saving) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .doc(id)
        .update(saving.toJson());
  }

  Future updateIncome(String id, Income income) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Income')
        .doc(id)
        .update(income.toJson());
  }

  Future deleteSaving(String id) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .doc(id)
        .delete();
  }

  Future deleteRemain(String id) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .doc(id)
        .collection("Remaining")
        .doc()
        .delete();
  }

  Future deleteIncome(String id) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Income')
        .doc(id)
        .delete();
  }

  Future deleteCategory(String id) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Category')
        .doc(id)
        .delete();
  }

  Stream<QuerySnapshot> getIncome() {
    return ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Income')
        .snapshots();
  }

  Stream<QuerySnapshot> getIn() {
    return ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Income')
        .where('income', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getOut() {
    return ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Income')
        .where('income', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getCategoryIncome() {
    return ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Category')
        .where('income', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getCategoryOut() {
    return ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Category')
        .where('income', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getRemaining(String id) {
    return ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .doc(id)
        .collection("Remaining")
        .snapshots();
  }

  Stream<QuerySnapshot> getMain() {
    return ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .snapshots();
  }

  Future deleteRemaining(String id, String remainID) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Saving')
        .doc(id)
        .collection("Remaining")
        .doc(remainID)
        .delete();
  }

  Future getCategoryIcon(String id) async {
    return await ref
        .doc('${FirebaseAuth.instance.currentUser!.email}')
        .collection('Category')
        .doc(id)
        .get();
  }

  Future<dynamic> fetchImages() async {
    List<dynamic> files = [];
    final ListResult result =
        await FirebaseStorage.instance.ref().child('Outcome').list();
    final List<Reference> allFiles = result.items;
    print(allFiles.length);

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      print('result is $fileUrl');

      files.add(
        fileUrl,
      );
    });
    FirebaseFirestore.instance.collection("Category").doc("Outcome").set({
      "url": files,
    });

    return files;
  }
}
