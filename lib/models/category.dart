import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:personal_financial/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  int icon;
  String? autoID;
  bool income;

  Category({required this.name, required this.icon, required this.income});

  factory Category.fromJson(Map<String, dynamic> json) => _incomeFromJson(json);

  factory Category.fromSnapshot(DocumentSnapshot snapshot) {
    final newIncome =
        Category.fromJson(snapshot.data() as Map<String, dynamic>);
    newIncome.autoID = snapshot.reference.id;
    return newIncome;
  }

  Map<String, dynamic> toJson() => _incomeToJson(this);

  @override
  String toString() => 'Income<$name>';
}

Category _incomeFromJson(Map<String, dynamic> json) {
  return Category(
      name: json['name'] as String,
      icon: json['icon'] as int,
      income: json['income'] as bool);
}

Map<String, dynamic> _incomeToJson(Category instance) => <String, dynamic>{
      'name': instance.name,
      'icon': instance.icon,
      'income': instance.income
    };
