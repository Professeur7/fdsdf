import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/client.dart';

class Habit {
  String? token;
  String image;
  String nomHabit;
  String? descriptionHabit;
  Client client;

  Habit(
      {required this.image,
      required this.nomHabit,
      this.descriptionHabit,
      required this.client,
      token});
  factory Habit.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final dataClient = file!["Client"];

    Client client;
    if (dataClient != null) {
      client = dataClient.map((element) => Client.fromSnapshot(element));
    } else {
      client = [] as Client;
    }

    return Habit(
        token: data.id,
        image: file["image"],
        nomHabit: file["nom tissu"],
        client: client);
  }
}
