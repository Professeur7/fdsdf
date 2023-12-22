import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SousTaches {
  String? token;
  bool valide;
  TimeOfDay debut;
  TimeOfDay fin;
  Timestamp date;
  String description;

  SousTaches(
      {required this.debut,
      required this.fin,
      required this.valide,
      required this.description,
      this.token,
      required this.date});

  factory SousTaches.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    return SousTaches(
      token: data.id,
      date: file!['date'],
      description: file["description"],
      valide: file["valide"],
      debut: file["Debut"],
      fin: file["Fin"],
    );
  }
}
