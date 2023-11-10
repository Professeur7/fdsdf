import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/commande.dart';

class Paiement {
  String? token;
  String montantPaye;
  DateTime datePaiement;
  Commande commande;

  Paiement(
      {required this.montantPaye,
      required this.datePaiement,
      required this.commande,
      token});
  factory Paiement.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final dataCommande = file!["Commande"];

    Commande commande;
    if (dataCommande != 0) {
      commande = dataCommande.map((element) => Commande.fromSnapshot(element));
    } else {
      commande = [] as Commande;
    }

    return Paiement(
      token: data.id,
      montantPaye: file["Montant"],
      datePaiement: file["Date paiement"],
      commande: commande,
    );
  }
}
