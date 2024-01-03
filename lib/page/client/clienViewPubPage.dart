import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/achatProduitModel.dart';
import 'package:fashion2/models/commandeModel.dart';
import 'package:fashion2/models/panierModel.dart';
import 'package:fashion2/models/pannier.dart';
import 'package:fashion2/models/produitModel.dart';
import 'package:fashion2/page/client/pageCommentaire.dart';
import 'package:fashion2/page/gridview/pagePromotion.dart';
import 'package:fashion2/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:video_player/video_player.dart';

import 'ProfilePublication.dart';

class PublicationsClient extends StatefulWidget {
  @override
  _PublicationsClientState createState() => _PublicationsClientState();
}

class _PublicationsClientState extends State<PublicationsClient>
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
    if (c.allPoste == []) {
    } else {
      for (final i in c.allPoste) {
        if (i.pub.isNotEmpty) {
          atelierLieux.add(i.lieux);
          atelierLogo.add(i.photAtelier);
          atelierName.add(i.atelierNAme);
          tailleurToken.add(i.tailleurToken);
          for (final c in i.pub) {
            imageLinks.add(c.images!.first.image);
          }
        }
      }
      if (c.allPoste.isNotEmpty) {
        for (final i in c.allPoste) {
          if (i.pub.isNotEmpty) comment.add(i.pub.first.description);
        }
      }
    }
    if (c.allVideoPostes == []) {
    } else {
      for (final i in c.allVideoPostes) {
        if (i.pub.isNotEmpty) {
          atelierLieuxVideo.add(i.lieux);
          atelierLogoVideo.add(i.photAtelier);
          atelierNameVideo.add(i.atelierNAme);
          for (final c in i.pub.first.videos!) {
            imageLinksvideo.add(c.video);
          }
        }
      }
      if (c.allVideoPostes.isNotEmpty) {
        for (final i in c.allVideoPostes) {
          if (i.pub.isNotEmpty) {
            commentvideo.add(i.pub.first.description);
          }
        }
      }
    }
  }

  List<String> imageLinks = [];
  List<String> comment = [];
  List<String> atelierName = [];
  List<String> atelierLieux = [];
  List<String> atelierLogo = [];
  List<String> tailleurToken = [];

  List<String> atelierNameVideo = [];
  List<String> atelierLieuxVideo = [];
  List<String> atelierLogoVideo = [];
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
            Navigator.pop(context);
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
            tailleurToken: tailleurToken,
            type: "Photos",
            photos: imageLinks,
            comments: comment,
            atelierLieux: atelierLieux,
            atelierLogo: atelierLogo,
            atelierName: atelierName,
          ),
          PublicationListVideo(
            atelierLieux: atelierLieuxVideo,
            atelierLogo: atelierLogoVideo,
            atelierName: atelierNameVideo,
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
  //FirebaseManagement _management = Get.put(FirebaseManagement());
  final String type;
  final List<String> photos;
  final List<String> comments;
  List<String> atelierName;
  List<String> atelierLieux;
  List<String> atelierLogo;
  List<String> tailleurToken;

  PublicationList(
      {required this.type,
      required this.atelierLieux,
      required this.atelierName,
      required this.atelierLogo,
      required this.photos,
      required this.tailleurToken,
      required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return PublicationTile(
          tailleurToken: tailleurToken[index],
          photoUrl: photos[index],
          comment: comments[index],
          workshopProfile: atelierLogo[index],
          type: type,
          workshopName: atelierName[index],
          workshopLocation: atelierLieux[index],
        );
      },
    );
  }
}

class PublicationListVideo extends StatelessWidget {
  //FirebaseManagement _management = Get.put(FirebaseManagement());
  final String type;
  final List<String> photos;
  final List<String> comments;
  List<String> atelierName;
  List<String> atelierLieux;
  List<String> atelierLogo;

  PublicationListVideo(
      {required this.type,
      required this.atelierLieux,
      required this.atelierName,
      required this.atelierLogo,
      required this.photos,
      required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return PublicationVideoTile(
          photoUrl: photos[index],
          comment: comments[index],
          type: type,
          workshopName: atelierName[index],
          workshopProfile: atelierLogo[index],
          workshopLocation: atelierLieux[index],
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
  final String tailleurToken;

  PublicationTile({
    required this.tailleurToken,
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
                                imageUrl: _management.atelier.first.imageUrl!,
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
                              _management.atelier.first.imageUrl!,
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
          ), // Si ce n'est pas une vidéo, afficher une image
          Image.network(widget.photoUrl),
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
                          final achat = AchatProduitModel(
                              nom: widget.workshopName,
                              description: widget.comment,
                              prix: 0,
                              image: widget.photoUrl,
                              qteCommande: 1);
                          PanierModel panierModel = PanierModel(
                              qteProduit: 1, prixTotal: 0, produit: [achat]);
                          _management.createPannier(
                              _management.clients.first.token!, panierModel);
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
                          final like = ProduitModel(
                              nom: widget.workshopName,
                              description: widget.comment,
                              prix: 0,
                              image: widget.photoUrl);
                          _management.addToLike(
                              _management.clients.first.token!, like);
                          if (isDisliked) {
                            isDisliked = false;
                            dislikeCount--;
                            // _management.deleteLike(
                            //     _management.clients.first.token!, like);
                          }
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Text('$likeCount'),
                  ],
                ),
                // Row(
                //   children: [
                //     IconButton(
                //       icon: Icon(
                //         Icons.thumb_down,
                //         color: dislikeCount > 0 ? Colors.orange : null,
                //       ),
                //       onPressed: () {
                //         setState(() {
                //           dislikeCount += isDisliked ? -1 : 1;
                //           isDisliked = !isDisliked;
                //           if (isLiked) {
                //             isLiked = false;
                //             likeCount--;
                //           }
                //         });
                //       },
                //     ),
                //     SizedBox(width: 4),
                //     Text('$dislikeCount'),
                //   ],
                // ),
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
                      final commande = CommandeModel(
                          tailleurToken: widget.tailleurToken,
                          firebaseToken: _management.clients.first.token!,
                          prix: 0,
                          dateCommande: DateTime.now(),
                          etatCommande: false,
                          produit: [
                            PanierModel(qteProduit: 0, prixTotal: 0, produit: [
                              AchatProduitModel(
                                  nom: widget.workshopName,
                                  description: widget.comment,
                                  prix: 0,
                                  image: widget.photoUrl,
                                  qteCommande: 1)
                            ])
                          ]);
                      _management.createCommande(
                          _management.clients.first.token!, commande);
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
                                imageUrl: _management.atelier.first.imageUrl!,
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
                              _management.atelier.first.imageUrl!,
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
                          final achat = AchatProduitModel(
                              nom: widget.workshopName,
                              description: widget.comment,
                              prix: 0,
                              image: widget.photoUrl,
                              qteCommande: 1);
                          PanierModel panierModel = PanierModel(
                              qteProduit: 1, prixTotal: 0, produit: [achat]);
                          _management.createPannier(
                              _management.clients.first.token!, panierModel);
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
                          final like = ProduitModel(
                              nom: widget.workshopName,
                              description: widget.comment,
                              prix: 0,
                              image: widget.photoUrl);
                          _management.addToLike(
                              _management.clients.first.token!, like);
                          if (isDisliked) {
                            isDisliked = false;
                            dislikeCount--;
                            // _management.deleteLike(
                            //     _management.clients.first.token!, like);
                          }
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Text('$likeCount'),
                  ],
                ),
                // Row(
                //   children: [
                //     IconButton(
                //       icon: Icon(
                //         Icons.thumb_down,
                //         color: dislikeCount > 0 ? Colors.orange : null,
                //       ),
                //       onPressed: () {
                //         setState(() {
                //           dislikeCount += isDisliked ? -1 : 1;
                //           isDisliked = !isDisliked;
                //           if (isLiked) {
                //             isLiked = false;
                //             likeCount--;
                //           }
                //         });
                //       },
                //     ),
                //     SizedBox(width: 4),
                //     Text('$dislikeCount'),
                //   ],
                // ),
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