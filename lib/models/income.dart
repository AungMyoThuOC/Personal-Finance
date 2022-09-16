import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:personal_financial/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Income {
  int amount;
  DateTime date;
  String category;
  String? autoID;
  String catName;
  bool income;

  Income(this.amount,
      {required this.date,
      required this.category,
      this.autoID,
      required this.catName,
      required this.income});

  factory Income.fromJson(Map<String, dynamic> json) => _incomeFromJson(json);

  factory Income.fromSnapshot(DocumentSnapshot snapshot) {
    final newIncome = Income.fromJson(snapshot.data() as Map<String, dynamic>);
    newIncome.autoID = snapshot.reference.id;
    return newIncome;
  }

  Map<String, dynamic> toJson() => _incomeToJson(this);

  @override
  String toString() => 'Income<$amount>';
}

Income _incomeFromJson(Map<String, dynamic> json) {
  return Income(json['amount'] as int,
      date: (json['date'] as Timestamp).toDate(),
      category: json['category'] as String,
      catName: json['catName'] as String,
      income: json['income'] as bool);
}

Map<String, dynamic> _incomeToJson(Income instance) => <String, dynamic>{
      'amount': instance.amount,
      'date': instance.date,
      'category': instance.category,
      'catName': instance.catName,
      'income': instance.income
    };
