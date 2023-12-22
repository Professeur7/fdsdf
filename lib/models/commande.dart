import 'package:fashion2/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Commande {
  String? token;
  String prix;
  DateTime dateCommande;
  String etatCommande;
  String? adresseLivraison;
  String? qteCommande;

  Commande(
      {required this.prix,
      this.qteCommande,
      required this.dateCommande,
      required this.etatCommande,
      this.adresseLivraison,
      this.token});
  factory Commande.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();

    return Commande(
        token: data.id,
        prix: file!["PrixTotal"],
        adresseLivraison: file["Adresse"],
        dateCommande: file["Date"],
        etatCommande: file["Etat"],
        qteCommande: file["qteCommande"]);
  }
}
