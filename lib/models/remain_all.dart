import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:personal_financial/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_financial/models/remaning_saving.dart';

class AllRemain {
  int amount;
  String date;

  AllRemain(
    this.amount, {
    required this.date,
  });

  factory AllRemain.fromJson(Map<String, dynamic> json) =>
      _incomeFromJson(json);

  factory AllRemain.fromSnapshot(DocumentSnapshot snapshot) {
    final newSaving =
        AllRemain.fromJson(snapshot.data() as Map<String, dynamic>);

    return newSaving;
  }

  Map<String, dynamic> toJson() => _incomeToJson(this);
}

AllRemain _incomeFromJson(Map<String, dynamic> json) {
  return AllRemain(json['amount'] as int, date: (json['date'] as String));
}

Map<String, dynamic> _incomeToJson(AllRemain instance) => <String, dynamic>{
      'amount': instance.amount,
      'date': instance.date,
    };
