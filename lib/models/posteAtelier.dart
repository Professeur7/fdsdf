import 'package:fashion2/models/poste.dart';
import 'package:fashion2/models/postevideo.dart';

class PostAtelier {
  List<Poste> pub;
  String atelierNAme;
  String lieux;
  String tailleurToken;
  String photAtelier;
  PostAtelier(
      {required this.tailleurToken,
      required this.atelierNAme,
      required this.lieux,
      required this.photAtelier,
      required this.pub});
}

class PostAtelierVideo {
  List<PosteVideo> pub;
  String atelierNAme;
  String lieux;
  String photAtelier;
  PostAtelierVideo(
      {required this.atelierNAme,
      required this.lieux,
      required this.photAtelier,
      required this.pub});
}
