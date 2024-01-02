import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/newProduitModel.dart';
import 'package:fashion2/models/produitModel.dart';

class CategorieModel {
  String firebaseToken; // Token Firebase pour la catégorie
  String nom;
  List<ProduitModel> listProduit;
  List<NewProductModel> listNews;

  CategorieModel({
    required this.firebaseToken,
    required this.nom,
    required this.listProduit,
    required this.listNews,
  });

  factory CategorieModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return CategorieModel(
      firebaseToken: snapshot.id,
      nom: data['Nom'] ?? '',
      listProduit: [], // Initialement vide, seront ajoutés plus tard
      listNews: [], // Initialement vide, seront ajoutés plus tard
    );
  }
}
