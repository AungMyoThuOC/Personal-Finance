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
  List<Remaining> vaccinations;
  DocumentReference? reference;

  Saving(this.amount,
      {required this.date, required this.target, required this.vaccinations});

  factory Saving.fromJson(Map<String, dynamic> json) => _incomeFromJson(json);

  factory Saving.fromSnapshot(DocumentSnapshot snapshot) {
    final newSaving = Saving.fromJson(snapshot.data() as Map<String, dynamic>);
    newSaving.autoID = snapshot.reference.id;
    return newSaving;
  }

  Map<String, dynamic> toJson() => _incomeToJson(this);
  @override
  String toString() => 'Pet<$autoID>';
}

Saving _incomeFromJson(Map<String, dynamic> json) {
  return Saving(
    json['amount'] as int,
    date: (json['date'] as Timestamp).toDate(),
    target: json['target'] as String,
    vaccinations: _convertVaccinations(json['vaccinations'] as List<dynamic>),
  );
}

Map<String, dynamic> _incomeToJson(Saving instance) => <String, dynamic>{
      'amount': instance.amount,
      'date': instance.date,
      'target': instance.target,
      'vaccinations': _vaccinationList(instance.vaccinations),
    };

List<Remaining> _convertVaccinations(List<dynamic> vaccinationMap) {
  final vaccinations = <Remaining>[];

  for (final vaccination in vaccinationMap) {
    vaccinations.add(Remaining.fromJson(vaccination as Map<String, dynamic>));
  }
  return vaccinations;
}

List<Map<String, dynamic>>? _vaccinationList(List<Remaining>? vaccinations) {
  if (vaccinations == null) {
    return null;
  }
  final vaccinationMap = <Map<String, dynamic>>[];
  vaccinations.forEach((vaccination) {
    vaccinationMap.add(vaccination.toJson());
  });
  return vaccinationMap;
}
