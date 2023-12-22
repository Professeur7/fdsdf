import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/image_model.dart';

class Models {
  String? token;
  String? nom;
  String? description;
  String prix;
  List<Images>? images;
  Models(
      {this.nom,
      this.token,
      this.description,
      required this.prix,
      this.images});
  factory Models.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final listImageData = file!['Images'];
    List<Images>? listImage;
    if (listImageData != null) {
      listImage = List<Images>.from(
          listImageData.map((element) => Images.fromSnapshot(element)));
    } else {
      listImage = [];
    }
    return Models(
        token: data.id,
        nom: file["nom"],
        prix: file["prix"],
        description: file["description"],
        images: listImage);
  }
}
