import 'dart:async';

import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/chat/message.dart';
import 'package:fashion2/models/commandeModel.dart';
import 'package:fashion2/page/client/clientDashboard.dart';
import 'package:fashion2/screen/clientHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

//import '../../screen/home_screen.dart';

class ClientOrderPage extends StatefulWidget {
  const ClientOrderPage({super.key});

  @override
  State<ClientOrderPage> createState() => _ClientOrderPageState();
}

class _ClientOrderPageState extends State<ClientOrderPage> {
  FirebaseManagement _management = Get.put(FirebaseManagement());
  function() async {
    await _management.getAllCommande(_management.clients.first.token!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    function();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Commandes '),
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _management.commandes
                    .length, // Remplacez par le nombre réel de commandes du client
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Naviguez vers la page de détails de la commande lorsqu'un élément est tapé.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientOrderDetailsPage(
                              orderNumber: index + 1,
                              commande: _management.commandes[index]),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                            'Commande #${_management.commandes[index].tailleurToken}'),
                        subtitle: Text('Description de la commande'),
                        trailing: Icon(Icons.message), // Icône de discussion
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientOrderDetailsPage extends StatelessWidget {
  final int orderNumber;
  CommandeModel commande;

  ClientOrderDetailsPage(
      {Key? key, required this.orderNumber, required this.commande})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09126C),
        title: Text('Détails de la Commande #$orderNumber'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context); // Revenir à la liste des commandes
          },
        ),
      ),
      body: Column(
        children: [
          // Affichez ici les détails spécifiques à la commande, tels que l'état, le coût, etc.
          SizedBox(height: 8.0),
          Text('État: En cours de traitement'),
          Text('Coût: \$100.00'),
          // ... Ajoutez d'autres détails de la commande
          // Ajoutez ici une section pour la discussion avec l'atelier (similaire à la page du tailleur)
          Expanded(
            child: ClientChatScreen(commande: commande),
          ),
        ],
      ),
    );
  }
}

class ClientChatScreen extends StatefulWidget {
  CommandeModel commande;

  ClientChatScreen({Key? key, required this.commande}) : super(key: key);

  @override
  State<ClientChatScreen> createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends State<ClientChatScreen> {
  FirebaseManagement _management = Get.put(FirebaseManagement());
  TextEditingController message = TextEditingController();

  late BehaviorSubject<List<MessageT>> _messagesStreamController;
  late StreamSubscription<List<MessageT>> _messagesSubscription;
  @override
  void initState() {
    super.initState();
    _messagesStreamController = BehaviorSubject<List<MessageT>>.seeded([]);
    _initializeMessagesStream();
  }

  void _initializeMessagesStream() {
    _messagesSubscription = _management
        .getMessages(widget.commande.clientToken, widget.commande.firebaseToken)
        .listen((messages) {
      _messagesStreamController.add(messages);
    });
  }

  @override
  void dispose() {
    _messagesStreamController.close();
    _messagesSubscription.cancel();
    super.dispose();
  }

  Stream<List<MessageT>> getMessagesStream() {
    return _messagesStreamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: StreamBuilder(
                stream: getMessagesStream(),
                builder: (context, snapshot) {
                  List<MessageT> m = snapshot.data ?? [];
                  return ListView.builder(
                      itemCount: m.length,
                      itemBuilder: (context, index) {
                        return MessageItem(message: m[index]);
                      });
                })),
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: message,
                  decoration:
                      InputDecoration(hintText: 'Écrivez un message...'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send), // Icône d'envoi de message
                onPressed: () {
                  // Ajoutez ici la logique pour envoyer le message
                  setState(() {
                    _management.createMessage(
                        _management.clients.first.token!,
                        widget.commande.firebaseToken,
                        MessageT(
                            message: message.text,
                            timestamp: DateTime.now(),
                            isTailleur: false));
                    message.clear();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MessageItem extends StatelessWidget {
  MessageT message;

  MessageItem({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:
          message.isTailleur ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(message.message),
        ),
        color: message.isTailleur
            ? Colors.blue
            : Colors.grey, // Couleur de fond du message
      ),
    );
  }
}
