import 'package:flutter/material.dart';

class CommentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laisser un commentaire'),
        backgroundColor: Colors.blue, // Couleur de l'appbar
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                maxLines: 8, // Nombre de lignes pour le champ de texte
                decoration: InputDecoration(
                  hintText: 'Entrez votre commentaire ici',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action à effectuer lors de l'envoi du commentaire
                // Insérez ici la logique pour soumettre le commentaire
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                primary: Colors.blue, // Couleur du bouton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Envoyer',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
