import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import '../../screen/clientHomeScreen.dart';

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
        backgroundColor: const Color(0xFF09126C),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ClientHomeScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Naviguez vers la page Favoris
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
        ],
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
              "https://www.facebook.com/watch/?v=368740601302632.mp4",
              "https://www.facebook.com/watch/?v=368740601302632.mp4",
              "https://www.facebook.com/watch/?v=368740601302632.mp4",
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

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoris'),
      ),
      body: Center(
        child: Text('Contenu de la page Favoris'),
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
          type: type, workshopName: 'Naf Couture', workshopProfile: '', workshopLocation: 'Garantibougou',
        );
      },
    );
  }
}

class PublicationTile extends StatefulWidget {
  final String photoUrl;
  final String comment;
  final String type;
  final String workshopName;
  final String workshopLocation;
  final String workshopProfile;

  PublicationTile({
    required this.photoUrl,
    required this.comment,
    required this.type,
    required this.workshopName,
    required this.workshopLocation,
    required this.workshopProfile,
  });

  @override
  _PublicationTileState createState() => _PublicationTileState();
}

class _PublicationTileState extends State<PublicationTile> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.photoUrl.endsWith('.mp4')) {
      _controller = VideoPlayerController.network(widget.photoUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    if (widget.photoUrl.endsWith('.mp4')) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.workshopProfile),
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Atelier: ${widget.workshopName}",
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Lieu: ${widget.workshopLocation}",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.photoUrl.endsWith('.mp4') && _controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),
                  if (!_isVideoPlaying)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isVideoPlaying = true;
                          _controller.play();
                        });
                      },
                      child: Icon(
                        Icons.play_arrow,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          if (!widget.photoUrl.endsWith('.mp4')) // Si ce n'est pas une vidéo, afficher une image
            Image.network(widget.photoUrl),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              widget.comment,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Text(
            "Type: ${widget.type}",
            style: TextStyle(fontSize: 12.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
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





