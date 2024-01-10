import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/chat/message.dart';
import 'package:fashion2/models/commande.dart';
import 'package:fashion2/models/panierModel.dart';

class CommandeModel {
  String firebaseToken;
  String clientToken;
  String? token;
  String tailleurToken;
  num prix;
  DateTime dateCommande;
  bool etatCommande;
  String? adresseLivraison;
  String? qteCommande;
  List<PanierModel> produit;
  List<MessageT>? message;

  CommandeModel({
    required this.clientToken,
    required this.tailleurToken,
    required this.firebaseToken,
    required this.prix,
    this.qteCommande,
    required this.dateCommande,
    required this.etatCommande,
    this.adresseLivraison,
    this.token,
    this.message,
    required this.produit,
  });

  static CommandeModel fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return CommandeModel(
      tailleurToken: data['tailleurToken'] ?? "",
      firebaseToken: snapshot.id,
      clientToken: data["clientToken"],
      prix: data["PrixTotal"],
      adresseLivraison: data["Adresse"] ?? "",
      dateCommande: data["Date"].toDate(),
      etatCommande: data["Etat"],
      qteCommande: data["qteCommande"] ?? "",
      message: [],
      produit: [], // Initialiser la liste des produits à vide
    );
  }
}
