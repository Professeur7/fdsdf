import 'package:dart_extensions/dart_extensions.dart';
import 'package:fashion2/firestore.dart';
import 'package:fashion2/page/client/pageCommentaire.dart';
import 'package:fashion2/page/gridview/pagePromotion.dart';
import 'package:fashion2/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:video_player/video_player.dart';

import '../../screen/clientHomeScreen.dart';
import '../profileAtelierPage.dart';
import 'ProfilePublication.dart';

class Publications extends StatefulWidget {
  @override
  _PublicationsState createState() => _PublicationsState();
}

class _PublicationsState extends State<Publications>
    with TickerProviderStateMixin {
  //FirebaseManagement _management = Get.put(FirebaseManagement());
  TabController? _tabController;
  bool isAddedToCart =
      false; // Exemple de variable pour savoir si l'article est ajouté au panier
  bool isLiked = false; // Exemple de variable pour savoir si l'article est aimé
  bool isDisliked =
      false; // Exemple de variable pour savoir si l'article n'est pas aimé
  bool isFavorite =
      false; // Exemple de variable pour savoir si l'article est favori

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    //c.getPublication(c.tailleurs.first.token!);
    //c.getVideoPublication(c.tailleurs.first.token!);
    print("it is");
    if (c.tailleurs.first.postes == []) {
    } else {
      for (final i in c.tailleurs.first.postes!) {
        for (final c in i.images!) {
          imageLinks.add(c.image);
        }
      }
      for (final i in c.tailleurs.first.postes!) {
        comment.add(i.description);
      }
    }
    if (c.tailleurs.first.posteVideos == []) {
    } else {
      for (final i in c.tailleurs.first.posteVideos!) {
        for (final c in i.videos!) {
          imageLinksvideo.add(c.video);
        }
      }
      for (final i in c.tailleurs.first.posteVideos!) {
        commentvideo.add(i.description);
      }
    }
  }

  List<String> imageLinks = [];
  List<String> comment = [];

  List<String> imageLinksvideo = [];
  List<String> commentvideo = [];

  final FirebaseManagement c = Get.put(FirebaseManagement());
  @override
  Widget build(BuildContext context) {
    print("lengh of video ${c.posteVideos.length}");
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
                builder: (context) => HomeScreen(),
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
                MaterialPageRoute(builder: (context) => NewPostPage()),
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
          indicator: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  25), // Ajustez le rayon selon votre besoin
            ),
            color: Colors.blue, // Couleur de l'indicateur
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PublicationList(
            type: "Photos",
            photos: imageLinks,
            comments: comment,
          ),
          PublicationListVideo(
            type: "Vidéos",
            photos: imageLinksvideo,
            comments: commentvideo,
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
  FirebaseManagement _management = Get.put(FirebaseManagement());
  final String type;
  final List<String> photos;
  final List<String> comments;

  PublicationList(
      {required this.type, required this.photos, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return PublicationTile(
          photoUrl: photos[index],
          comment: comments[index],
          type: type,
          workshopName:
              '${_management.atelier.length != 0 ? _management.atelier.first.nom : ""}',
          workshopProfile: '',
          workshopLocation:
              '${_management.atelier.length != 0 ? _management.atelier.first.lieu : ""}',
        );
      },
    );
  }
}

class PublicationListVideo extends StatelessWidget {
  FirebaseManagement _management = Get.put(FirebaseManagement());
  final String type;
  final List<String> photos;
  final List<String> comments;

  PublicationListVideo(
      {required this.type, required this.photos, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return PublicationVideoTile(
          photoUrl: photos[index],
          comment: comments[index],
          type: type,
          workshopName:
              '${_management.atelier.length != 0 ? _management.atelier.first.nom : ""}',
          workshopProfile: '',
          workshopLocation:
              '${_management.atelier.length != 0 ? _management.atelier.first.lieu : ""}',
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
  FirebaseManagement _management = Get.put(FirebaseManagement());
  late VideoPlayerController _controller;
  bool _isVideoPlaying = false;
  bool isAddedToCart =
      false; // Exemple de variable pour savoir si l'article est ajouté au panier
  bool isLiked = false; // Exemple de variable pour savoir si l'article est aimé
  bool isDisliked =
      false; // Exemple de variable pour savoir si l'article n'est pas aimé
  bool isFavorite =
      false; // Exemple de variable pour savoir si l'article est favori
  int likeCount = 0;
  int dislikeCount = 0;
  int cartCount = 0;
  int favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.photoUrl.endsWith('.mp4')) {
      // ignore: deprecated_member_use
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                name: ModalRoute.of(context)!
                                    .settings
                                    .arguments
                                    .toString(), // Exemple de récupération dynamique du nom depuis les arguments de la route
                                location:
                                    '${_management.atelier.length != 0 ? _management.atelier.first.lieu : ""}',
                                imageUrl: _management.atelier.first.imageUrl,
                              )),
                    );
                    // Naviguer vers la nouvelle page de profil ici
                    // Vous devez définir votre propre logique de navigation
                    // Par exemple, vous pouvez utiliser Navigator pour naviguer vers la nouvelle page.
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: _management.atelier.length == 0
                        ? Container()
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(
                              _management.atelier.first.imageUrl,
                            ),
                          ),
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     var location = "Garantibougou";
                //     var imageUrl =
                //         "https://w7.pngwing.com/pngs/650/656/png-transparent-model-fashion-model-celebrities-woman-fashion-model-thumbnail.png";
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => ProfilePage(
                //                 name: ModalRoute.of(context)!
                //                     .settings
                //                     .arguments
                //                     .toString(), // Exemple de récupération dynamique du nom depuis les arguments de la route
                //                 location: location = "",
                //                 imageUrl: imageUrl,
                //               )),
                //     );
                //     // Votre logique de navigation pour le profil de l'atelier ici
                //   },
                // ),
                SizedBox(width: 14.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " ${widget.workshopName}",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${widget.workshopLocation}",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ],
            ),
          ), // Si ce n'est pas une vidéo, afficher une image
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart,
                        color: cartCount > 0 ? Colors.green : null,
                      ),
                      onPressed: () {
                        setState(() {
                          cartCount += isAddedToCart ? -1 : 1;
                          isAddedToCart = !isAddedToCart;
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Text('$cartCount'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: favoriteCount > 0 ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          favoriteCount += isFavorite ? -1 : 1;
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Text('$favoriteCount'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: likeCount > 0 ? Colors.blue : null,
                      ),
                      onPressed: () {
                        setState(() {
                          likeCount += isLiked ? -1 : 1;
                          isLiked = !isLiked;
                          if (isDisliked) {
                            isDisliked = false;
                            dislikeCount--;
                          }
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Text('$likeCount'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_down,
                        color: dislikeCount > 0 ? Colors.orange : null,
                      ),
                      onPressed: () {
                        setState(() {
                          dislikeCount += isDisliked ? -1 : 1;
                          isDisliked = !isDisliked;
                          if (isLiked) {
                            isLiked = false;
                            likeCount--;
                          }
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Text('$dislikeCount'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPage(),
                        ),
                      );
                      // Ajoutez ici la logique pour laisser un commentaire
                    },
                    child: Text("Laisser un commentaire"),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Ajoutez ici la logique pour laisser un commentaire
                    },
                    child: Text("Passer une commande"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PublicationVideoTile extends StatefulWidget {
  final String photoUrl;
  final String comment;
  final String type;
  final String workshopName;
  final String workshopLocation;
  final String workshopProfile;

  PublicationVideoTile({
    required this.photoUrl,
    required this.comment,
    required this.type,
    required this.workshopName,
    required this.workshopLocation,
    required this.workshopProfile,
  });

  @override
  _PublicationVideoTileState createState() => _PublicationVideoTileState();
}

class _PublicationVideoTileState extends State<PublicationVideoTile> {
  FirebaseManagement _management = Get.put(FirebaseManagement());
  late VideoPlayerController _controller;
  bool _isVideoPlaying = false;
  bool isAddedToCart =
      false; // Exemple de variable pour savoir si l'article est ajouté au panier
  bool isLiked = false; // Exemple de variable pour savoir si l'article est aimé
  bool isDisliked =
      false; // Exemple de variable pour savoir si l'article n'est pas aimé
  bool isFavorite =
      false; // Exemple de variable pour savoir si l'article est favori
  int likeCount = 0;
  int dislikeCount = 0;
  int cartCount = 0;
  int favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(widget.photoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                name: ModalRoute.of(context)!
                                    .settings
                                    .arguments
                                    .toString(), // Exemple de récupération dynamique du nom depuis les arguments de la route
                                location:
                                    '${_management.atelier.length != 0 ? _management.atelier.first.lieu : ""}',
                                imageUrl: _management.atelier.first.imageUrl,
                              )),
                    );
                    // Naviguer vers la nouvelle page de profil ici
                    // Vous devez définir votre propre logique de navigation
                    // Par exemple, vous pouvez utiliser Navigator pour naviguer vers la nouvelle page.
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: _management.atelier.length == 0
                        ? Container()
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(
                              _management.atelier.first.imageUrl,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 14.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " ${widget.workshopName}",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " ${widget.workshopLocation}",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              widget.comment,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart,
                        color: cartCount > 0 ? Colors.green : null,
                      ),
                      onPressed: () {
                        setState(() {
                          cartCount += isAddedToCart ? -1 : 1;
                          isAddedToCart = !isAddedToCart;
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Text('$cartCount'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: favoriteCount > 0 ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          favoriteCount += isFavorite ? -1 : 1;
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Text('$favoriteCount'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: likeCount > 0 ? Colors.blue : null,
                      ),
                      onPressed: () {
                        setState(() {
                          likeCount += isLiked ? -1 : 1;
                          isLiked = !isLiked;
                          if (isDisliked) {
                            isDisliked = false;
                            dislikeCount--;
                          }
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Text('$likeCount'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.thumb_down,
                        color: dislikeCount > 0 ? Colors.orange : null,
                      ),
                      onPressed: () {
                        setState(() {
                          dislikeCount += isDisliked ? -1 : 1;
                          isDisliked = !isDisliked;
                          if (isLiked) {
                            isLiked = false;
                            likeCount--;
                          }
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Text('$dislikeCount'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPage(),
                        ),
                      );
                      // Ajoutez ici la logique pour laisser un commentaire
                    },
                    child: Text("Laisser un commentaire"),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Ajoutez ici la logique pour laisser un commentaire
                    },
                    child: Text("Passer une commande"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
