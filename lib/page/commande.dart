import 'dart:async';

import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/chat/message.dart';
import 'package:fashion2/models/client.dart';
import 'package:fashion2/models/commandeModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../screen/home_screen.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  FirebaseManagement _management = Get.put(FirebaseManagement());
  List<CommandeModel> listCommande = [];
  List<MessageT> messages = [];
  List<Client> clientss = [];
  bool isLoading = true;

  Future<void> loadData() async {
    await _management.tailleurCommande();
    listCommande = _management.commandestailleurs;
    for (var element in _management.commandestailleurs) {
      var client = await _management.getCli(element.clientToken);
      if (client != null) {
        clientss.add(client);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demandes de Commande'),
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
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Afficher un indicateur de chargement si les clients ne sont pas encore chargés
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: listCommande.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(commande: listCommande[index]),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.all(10),
                            child: ListTile(
                              leading: Icon(Icons.message),
                              title: Text(
                                'Demande de commande ${clientss[index].nom!} ${clientss[index].prenom!}',
                              ),
                              subtitle:
                                  Text('${listCommande[index].dateCommande}'),
                              trailing: listCommande[index].etatCommande
                                  ? Icon(
                                      Icons.delivery_dining,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.delivery_dining,
                                      color: Colors.red,
                                    ),
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

class ChatScreen extends StatefulWidget {
  ChatScreen({required this.commande});
  CommandeModel commande;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseManagement _management = Get.put(FirebaseManagement());
  TextEditingController messageController = TextEditingController();
  late BehaviorSubject<List<MessageT>> _messagesStreamController;
  late StreamSubscription<List<MessageT>> _messagesSubscription;
  //static bool isListing = true;

  @override
  void initState() {
    super.initState();
    _messagesStreamController = BehaviorSubject<List<MessageT>>.seeded([]);
    _initializeMessagesStream();
    //isListing = false;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09126C),
        title: Text('Discussion avec le client'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(
                context); // Revenir à la liste des demandes de commande
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  _management.updateCommande(widget.commande.clientToken,
                      widget.commande.firebaseToken, true);
                });
              },
              child: Text("Valider la commande"))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: StreamBuilder(
                    stream: getMessagesStream(),
                    builder: (context, snapshot) {
                      List<MessageT> m = snapshot.data ?? [];
                      return ListView.builder(
                          reverse: true,
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
                      controller: messageController,
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
                            widget.commande.clientToken,
                            widget.commande.firebaseToken,
                            MessageT(
                                message: messageController.text,
                                timestamp: DateTime.now(),
                                isTailleur: true));
                        messageController.text = "";
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
