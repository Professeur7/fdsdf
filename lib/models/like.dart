import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Like {
  String? nom;
  String? description;
  String? prix;
  bool? like;
  Image image;
  String? token;

  Like(
      {this.nom,
      this.description,
      required this.image,
      this.like,
      this.prix,
      this.token});

  factory Like.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();

    return Like(
        prix: file!["prix"],
        image: file["image"],
        nom: file["produitName"],
        description: file["description"],
        token: data.id,
        like: file["like"]);
  }
}
