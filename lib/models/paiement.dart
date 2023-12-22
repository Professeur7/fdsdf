import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/habit.dart';
import 'package:fashion2/models/mesClients.dart';

class Paiement {
  String? token;
  String montantPaye;
  DateTime datePaiement;
  List<MesClients> client;
  List<Habit> habit;

  Paiement(
      {required this.montantPaye,
      required this.client,
      required this.habit,
      required this.datePaiement,
      token});
  factory Paiement.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final dataHabit = file!["Habit"];
    final dataClient = file["Client"];

    Habit habit;
    if (dataHabit != null) {
      habit = dataHabit.map((element) => Habit.fromSnapshot(element));
    } else {
      habit = [] as Habit;
    }

    MesClients client;
    if (dataClient != null) {
      client = dataClient.map((element) => MesClients.fromSnapshot(element));
    } else {
      client = [] as MesClients;
    }

    return Paiement(
      token: data.id,
      client: [client],
      habit: [habit],
      montantPaye: file["Montant"],
      datePaiement: file["Date paiement"],
    );
  }
}
