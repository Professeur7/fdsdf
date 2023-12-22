import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String? token;
  String video;

  Video({required this.video, this.token});

  factory Video.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) =>
      Video(
        token: data.id,
        video: data['image'] as String,
      );
}
