import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/video_model.dart';

class PosteVideo {
  String? token;
  String description;
  DateTime date;
  List<Video>? videos;
  PosteVideo(
      {required this.description, this.videos, this.token, required this.date});
  factory PosteVideo.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final listImageData = file!['Videos'];
    List<Video>? listImage;
    if (listImageData != null) {
      listImage = List<Video>.from(
          listImageData.map((element) => Video.fromSnapshot(element)));
    } else {
      listImage = [];
    }

    return PosteVideo(
        date: file['date'].toDate(),
        token: data.id,
        description: file['description'],
        videos: listImage);
  }
}
