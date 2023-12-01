import 'package:fashion2/models/tailleurs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/client.dart';

class RDV {
  String? token;
  String? motif; // Ajout de la variable pour le nom du client
  DateTime date;// Changement de dateRDV en date, car vous utilisez déjà ce nom dans le constructeur
  String client;
  String? client_image;

  RDV({
    this.client_image,
    required this.date,
    this.token,
    required this.client,
    this.motif,
  });

  factory RDV.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();

    return RDV(
      client_image: file!['client_image'],
      token: data.id,
      client: file['client_name'],
      motif: file["motif"], // Assurez-vous que le champ dans Firestore est nommé correctement
      date: file["dateRDV"].toDate(), // Utilisation de toDate() pour convertir en DateTime
    );
  }
}

