import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:personal_financial/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_financial/models/remaning_saving.dart';

class Remaining {
  int amount;
  DateTime date;
  String? remainID;

  Remaining(
    this.amount, {
    required this.date,
  });

  factory Remaining.fromJson(Map<String, dynamic> json) =>
      _incomeFromJson(json);

  factory Remaining.fromSnapshot(DocumentSnapshot snapshot) {
    final newSaving =
        Remaining.fromJson(snapshot.data() as Map<String, dynamic>);
    newSaving.remainID = snapshot.reference.id;
    print(newSaving.remainID);
    return newSaving;
  }

  Map<String, dynamic> toJson() => _incomeToJson(this);
}

Remaining _incomeFromJson(Map<String, dynamic> json) {
  return Remaining(
    json['amount'] as int,
    date: (json['date'] as Timestamp).toDate(),
  );
}

Map<String, dynamic> _incomeToJson(Remaining instance) => <String, dynamic>{
      'amount': instance.amount,
      'date': instance.date,
    };
