import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/image_model.dart';

class Poste {
  String? token;
  String description;
  DateTime date;
  List<Images>? images;
  Poste(
      {required this.description, this.images, this.token, required this.date});
  factory Poste.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final listImageData = file!['Images'];
    List<Images>? listImage;
    if (listImageData != null) {
      listImage = List<Images>.from(
          listImageData.map((element) => Images.fromSnapshot(element)));
    } else {
      listImage = [];
    }
    return Poste(
        date: file['date'],
        token: data.id,
        description: file['description'],
        images: listImage);
  }
}
