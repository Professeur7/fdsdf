import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/commande.dart';
import 'package:fashion2/models/panierModel.dart';

class CommandeModel {
  String firebaseToken;
  String? token;
  num prix;
  DateTime dateCommande;
  bool etatCommande;
  String? adresseLivraison;
  String? qteCommande;
  List<PanierModel> produit;

  CommandeModel({
    required this.firebaseToken,
    required this.prix,
    this.qteCommande,
    required this.dateCommande,
    required this.etatCommande,
    this.adresseLivraison,
    this.token,
    required this.produit,
  });

  static CommandeModel fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return CommandeModel(
      firebaseToken: snapshot.id,
      prix: data["PrixTotal"],
      adresseLivraison: data["Adresse"],
      dateCommande: data["Date"],
      etatCommande: data["Etat"],
      qteCommande: data["qteCommande"],
      produit: [], // Initialiser la liste des produits à vide
    );
  }
}
