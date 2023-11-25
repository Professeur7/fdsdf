import 'package:flutter/material.dart';

import '../screen/home_screen.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09126C),
        title: Text('Demandes de Commande'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Remplacez par le nombre réel de demandes de commande
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Naviguez vers la page de discussion lorsqu'un élément est tapé.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('Demande de commande $index'),
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

class ChatScreen extends StatelessWidget {
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
            Navigator.pop(context); // Revenir à la liste des demandes de commande
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // Affichez la liste des messages ici
              children: [
                MessageItem(isTailor: false, text: "Bonjour, j'ai besoin de votre aide."),
                MessageItem(isTailor: true, text: "Bonjour! Comment puis-je vous aider?"),
                MessageItem(isTailor: true, text: "Quel type de commande recherchez-vous?"),
                // ... Ajoutez d'autres messages
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Écrivez un message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send), // Icône d'envoi de message
                  onPressed: () {
                    // Ajoutez ici la logique pour envoyer le message
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  final bool isTailor;
  final String text;

  MessageItem({required this.isTailor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isTailor ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(text),
        ),
        color: isTailor ? Colors.blue : Colors.grey, // Couleur de fond du message
      ),
    );
  }
}
