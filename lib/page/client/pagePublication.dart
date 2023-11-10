import 'package:flutter/material.dart';

class Publications extends StatefulWidget {
  @override
  _PublicationsState createState() => _PublicationsState();
}

class _PublicationsState extends State<Publications> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Publications"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Photos"),
            Tab(text: "Vidéos"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PublicationList(
            type: "Photos",
            photos: [
              "https://w7.pngwing.com/pngs/650/656/png-transparent-model-fashion-model-celebrities-woman-fashion-model-thumbnail.png",
              "https://w7.pngwing.com/pngs/650/656/png-transparent-model-fashion-model-celebrities-woman-fashion-model-thumbnail.png",
              "https://w7.pngwing.com/pngs/650/656/png-transparent-model-fashion-model-celebrities-woman-fashion-model-thumbnail.png",
              // Ajoutez d'autres URLs de photos ici
            ],
            comments: [
              "Contenu de la publication 1...",
              "Contenu de la publication 2...",
              "Contenu de la publication 3...",
              // Ajoutez d'autres commentaires ici
            ],
          ),
          PublicationList(
            type: "Vidéos",
            photos: [
              "https://youtu.be/05GeRFy2FM4?si=-t9aGb_TfJOS10-_.mp4",
              "https://youtu.be/05GeRFy2FM4?si=-t9aGb_TfJOS10-_.mp4",
              "https://youtu.be/05GeRFy2FM4?si=-t9aGb_TfJOS10-_.mp4",
              // Ajoutez d'autres URLs de vidéos ici
            ],
            comments: [
              "Contenu de la vidéo 1...",
              "Contenu de la vidéo 2...",
              "Contenu de la vidéo 3...",
              // Ajoutez d'autres commentaires ici
            ],
          ),
        ],
      ),
    );
  }
}

class PublicationList extends StatelessWidget {
  final String type;
  final List<String> photos;
  final List<String> comments;

  PublicationList({required this.type, required this.photos, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return PublicationTile(
          photoUrl: photos[index],
          comment: comments[index],
          type: type,
        );
      },
    );
  }
}

class PublicationTile extends StatelessWidget {
  final String photoUrl;
  final String comment;
  final String type;

  PublicationTile({required this.photoUrl, required this.comment, required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(photoUrl),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              comment,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Text(
            "Type: $type",
            style: TextStyle(fontSize: 12.0),
          ),
          // Bouton pour laisser un commentaire
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Ajoutez ici la logique pour laisser un commentaire
              },
              child: Text("Laisser un commentaire"),
            ),
          ),
        ],
      ),
    );
  }
}
