import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  String? token;
  String image;
  String? descriptionHabit;

  Habit({required this.image, this.descriptionHabit, token});
  factory Habit.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();

    return Habit(
      token: data.id,
      image: file!["image"],
    );
  }
}
