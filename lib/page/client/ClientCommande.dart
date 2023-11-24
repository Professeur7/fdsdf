import 'package:flutter/material.dart';

import '../../screen/home_screen.dart';

class ClientOrderPage extends StatefulWidget {
  const ClientOrderPage({super.key});

  @override
  State<ClientOrderPage> createState() => _ClientOrderPageState();
}

class _ClientOrderPageState extends State<ClientOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Commandes'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Liste de mes commandes",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Remplacez par le nombre réel de commandes du client
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Naviguez vers la page de détails de la commande lorsqu'un élément est tapé.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientOrderDetailsPage(orderNumber: index + 1),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('Commande #${index + 1}'),
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

  const ClientOrderDetailsPage({Key? key, required this.orderNumber}) : super(key: key);

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
            child: ClientChatScreen(orderNumber: orderNumber),
          ),
        ],
      ),
    );
  }
}

class ClientChatScreen extends StatelessWidget {
  final int orderNumber;

  const ClientChatScreen({Key? key, required this.orderNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            // Affichez la liste des messages ici
            children: [
              MessageItem(isTailor: true, text: "Bonjour! Comment puis-je vous aider?"),
              MessageItem(isTailor: false, text: "Bonjour, j'ai besoin de votre aide."),
              MessageItem(isTailor: false, text: "Je voudrais discuter de ma commande #$orderNumber."),
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
