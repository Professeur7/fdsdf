import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Produit {
  String? nom;
  String? description;
  String? prix;
  bool? like;
  Image image;
  String? qteCommande;
  String? token;

  Produit(
      {this.nom,
      this.description,
      required this.image,
      this.like,
      this.prix,
      this.qteCommande,
      this.token});

  factory Produit.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();

    return Produit(
        prix: file!["prix"],
        image: file["image"],
        nom: file["produitName"],
        description: file['supplier'],
        token: data.id,
        like: file["produitPrix"],
        qteCommande: file["qteStock"]);
  }
}
