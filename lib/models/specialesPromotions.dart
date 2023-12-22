import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialPromotion {
  String title;
  String description;
  String imageUrl;
  String date;
  String? token;

  SpecialPromotion(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.date,
      this.token});
  factory SpecialPromotion.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();

    return SpecialPromotion(
      title: file!["prix"],
      imageUrl: file["image"],
      description: file["produitName"],
      token: data.id,
      date: file["produitPrix"],
    );
  }
}
