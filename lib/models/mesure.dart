import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/client.dart';
import 'package:fashion2/models/models.dart';
import 'package:fashion2/models/tailleurs.dart';

class Mesures {
  String? token;
  String? tourPoitrine;
  String? tourTaille;
  String? tourDos;
  String? tourHanche;
  String? longueurManches;
  String? largeursEpaules;
  String? longueurJambes;
  String? hauteurEntrejambe;
  String? longueurOurlet;
  String? tourBras;
  String? tourPoignet;
  String? hauteurTotale;
  String? tourCou;
  Tailleurs? tailleurs;
  Models? models;
  Client? client;

  Mesures(
      {this.tailleurs,
      this.client,
      this.models,
      this.tourPoitrine,
      this.tourTaille,
      this.tourDos,
      this.tourHanche,
      this.longueurManches,
      this.largeursEpaules,
      this.longueurJambes,
      this.hauteurEntrejambe,
      this.longueurOurlet,
      this.tourBras,
      this.tourPoignet,
      this.hauteurTotale,
      this.tourCou,
      token});
  factory Mesures.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final dataClient = file!["Client"];
    final dataTailleur = file["Tailleur"];
    final dataModels = file["Models"];

    Tailleurs tailleurs;
    if (dataTailleur != null) {
      tailleurs =
          dataTailleur.map((element) => Tailleurs.fromSnapshot(element));
    } else {
      tailleurs = [] as Tailleurs;
    }

    Client client;
    if (dataClient != null) {
      client = dataClient.map((element) => Client.fromSnapshot(element));
    } else {
      client = [] as Client;
    }

    Models models;
    if (dataModels != null) {
      models = dataModels.map((element) => Models.fromSnapshot(element));
    } else {
      models = [] as Models;
    }

    return Mesures(
      token: data.id,
      client: client,
      tailleurs: tailleurs,
      models: models,
      tourPoitrine: file['poitrine'],
      tourTaille: file['taille'],
      tourDos: file['dos'],
      tourHanche: file['hanche'],
      longueurManches: file['manche'],
      largeursEpaules: file['epaule'],
      longueurJambes: file['jambe'],
      hauteurEntrejambe: file['entreJambe'],
      longueurOurlet: file['ourlet'],
      tourBras: file['bras'],
      tourPoignet: file['poignet'],
      hauteurTotale: file['totale'],
      tourCou: file['cou'],
    );
  }
}
