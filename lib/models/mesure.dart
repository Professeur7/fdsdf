import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/client.dart';
import 'package:fashion2/models/habit.dart';
import 'package:fashion2/models/mesClients.dart';
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
  List<Models> models;
  List<MesClients> client;
  List<Habit> habit;
  String? avance;
  String? reste;

  Mesures(
      {required this.client,
      required this.models,
      required this.habit,
      this.avance,
      this.reste,
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
      this.token});
  factory Mesures.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final dataClient = file!["Client"];
    final dataModels = file["Models"];
    final dataHabit = file["Habit"];

    List<Habit> habit;
    if (dataHabit != null) {
      habit = dataHabit.map((element) => Habit.fromSnapshot(element));
    } else {
      habit = [];
    }

    List<MesClients> client;
    if (dataClient != null) {
      client = dataClient.map((element) => MesClients.fromSnapshot(element));
    } else {
      client = [];
    }

    List<Models> models;
    if (dataModels != null) {
      models = dataModels.map((element) => Models.fromSnapshot(element));
    } else {
      models = [];
    }

    return Mesures(
      token: data.id,
      client: client,
      habit: habit,
      models: models,
      tourBras: file["tourBras"],
      tourDos: file["tourDos"],
      tourCou: file["tourCou"],
      tourHanche: file["tourHanche"],
      tourPoignet: file["tourPoignet"],
      tourPoitrine: file["tourPoignet"],
      tourTaille: file["tourTaille"],
      longueurJambes: file["longueurJambes"],
      longueurManches: file["longueurManches"],
      longueurOurlet: file["longueurOurlet"],
      largeursEpaules: file["largeursEpaules"],
      hauteurTotale: file["hauteurTotale"],
      reste: file["reste"],
      avance: file["avance"],
    );
  }
}
