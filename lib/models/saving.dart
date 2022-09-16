import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:personal_financial/firebase_options.dart';
import 'package:personal_financial/models/remaning_saving.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Saving {
  int amount;
  DateTime date;
  String target;
  String? autoID;

  Saving(
    this.amount, {
    required this.date,
    required this.target,
  });

  factory Saving.fromJson(Map<String, dynamic> json) => _incomeFromJson(json);

  factory Saving.fromSnapshot(DocumentSnapshot snapshot) {
    final newSaving = Saving.fromJson(snapshot.data() as Map<String, dynamic>);
    newSaving.autoID = snapshot.reference.id;

    return newSaving;
  }

  Map<String, dynamic> toJson() => _incomeToJson(this);
}

Saving _incomeFromJson(Map<String, dynamic> json) {
  return Saving(
    json['amount'] as int,
    date: (json['date'] as Timestamp).toDate(),
    target: json['target'] as String,
  );
}

Map<String, dynamic> _incomeToJson(Saving instance) => <String, dynamic>{
      'amount': instance.amount,
      'date': instance.date,
      'target': instance.target,
    };
