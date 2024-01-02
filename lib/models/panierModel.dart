import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/achatProduitModel.dart';

class PanierModel {
  String? token;
  int qteProduit;
  double prixTotal;
  //List<ProduitModel> listProduit;
  List<AchatProduitModel> produit;

  PanierModel(
      {this.token,
      required this.qteProduit,
      required this.prixTotal,
      //required this.listProduit,
      required this.produit});

  static PanierModel fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return PanierModel(
        token: snapshot.id,
        qteProduit: data['qteProduit'],
        prixTotal: data['prixTotal'],
        //listProduit: [],
        produit: []);
  }
}
