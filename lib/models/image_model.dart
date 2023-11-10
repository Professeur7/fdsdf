import 'package:cloud_firestore/cloud_firestore.dart';

class Images {
  String? token;
  String image;

  Images({required this.image, this.token});

  factory Images.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) =>
      Images(
        token: data.id,
        image: data['image'] as String,
      );
}
