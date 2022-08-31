import './models/income.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('Income');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addIncome(Income income) {
    return collection.add(income.toJson());
  }
}
