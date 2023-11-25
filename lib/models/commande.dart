import 'package:fashion2/models/models.dart';
import 'package:fashion2/models/tailleurs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/client.dart';

class Commande {
  String? token;
  String prixConvenu;
  DateTime dateCommande;
  DateTime dateLivraison;
  String tailleurs;
  Models models;
  Commande(
      {required this.prixConvenu,
      required this.dateCommande,
      required this.dateLivraison,
      required this.tailleurs,
      required this.models,
      token});
  factory Commande.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final dataModel = file!["Models"];

    Models models;
    if (dataModel != null) {
      models = dataModel.map((element) => Models.fromSnapshot(element));
    } else {
      models = [] as Models;
    }

    return Commande(
        token: data.id,
        prixConvenu: file["Prix Convenu"],
        dateCommande: file["date Commande"],
        dateLivraison: file["date Livraison"],
        tailleurs: file["tailleurs"],
        models: models);
  }
}


/*class Commande{
  String prixConvenu;
  String dateCommande;
  String dateLivraison;

  Commande({
    required this.prixConvenu, required this.dateCommande,required this.dateLivraison 
  });
    factory Images.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    return 
  }

}*/