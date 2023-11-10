import 'package:fashion2/models/tailleurs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/client.dart';

class RDV {
  String? token;
  String? motif;
  DateTime dateRDV;
  Client client;
  Tailleurs tailleurs;
  RDV(
      {required this.dateRDV,
      this.motif,
      required this.client,
      required this.tailleurs,
      token});
  factory RDV.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final dataClient = file!["Client"];
    final dataTailleur = file["Tailleur"];

    Client client;
    if (dataClient != null) {
      client = dataClient.map((element) => Client.fromSnapshot(element));
    } else {
      client = [] as Client;
    }

    Tailleurs tailleurs;
    if (dataTailleur != null) {
      tailleurs =
          dataTailleur.map((element) => Tailleurs.fromSnapshot(element));
    } else {
      tailleurs = [] as Tailleurs;
    }

    return RDV(
      token: data.id,
      dateRDV: file["dateRDV"],
      client: client,
      tailleurs: tailleurs,
    );
  }
}
