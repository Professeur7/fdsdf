import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/image_model.dart';

class Albums {
  String? token;
  String nom;
  List<Images>? images;
  Albums({required this.nom, this.token, this.images});
  factory Albums.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final listImageData = file!['Images'];
    List<Images>? listImage;
    if (listImageData != null) {
      listImage = List<Images>.from(
          listImageData.map((element) => Images.fromSnapshot(element)));
    } else {
      listImage = [];
    }
    return Albums(token: data.id, nom: file["nom"], images: listImage);
  }
}
