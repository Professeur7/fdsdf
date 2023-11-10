import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/tailleurs.dart';

class Taches {
  String? token;
  String? valide;
  DateTime dateDebut;
  DateTime dateFin;
  String? description;
  Tailleurs? tailleurs;

  Taches(
      {required this.dateDebut,
      this.tailleurs,
      required this.dateFin,
      this.valide,
      this.description,
      token});
  factory Taches.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final dataTailleur = file!["Tailleur"];

    Tailleurs tailleurs;
    if (dataTailleur != null) {
      tailleurs =
          dataTailleur.map((element) => Tailleurs.fromSnapshot(element));
    } else {
      tailleurs = [] as Tailleurs;
    }

    return Taches(
      token: data.id,
      tailleurs: tailleurs,
      dateDebut: file["dateDebut"],
      dateFin: file["dateFin"],
    );
  }
}
