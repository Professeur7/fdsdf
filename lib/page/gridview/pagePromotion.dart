import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../screen/home_screen.dart';


class MarketingAndPromotionPage extends StatelessWidget {
  void shareOnSocialMedia() async {
    await FlutterShare.share(
      title: 'Partagez sur les médias sociaux',
      text: 'Découvrez notre atelier de couture !',
      linkUrl: 'https://votre-site-web.com',
    );
  }

  void sendMarketingEmail() async {
    final smtpServer = gmail('votre-email@gmail.com', 'votre-mot-de-passe');

    final message = Message()
      ..from = Address('votre-email@gmail.com', 'Votre Nom')
      ..recipients.add('destinataire@example.com')
      ..subject = 'Sujet de l\'e-mail'
      ..text = 'Contenu de l\'e-mail';

    try {
      final sendReport = await send(message, smtpServer);
      if (sendReport != null) {
        print('Message envoyé avec succès');
      } else {
        print('Erreur d\'envoi');
      }
    } catch (e) {
      print('Erreur d\'envoi : $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Marketing et Promotion"),
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
                builder: (context) => HomeScreen(), // Remplacez PageDefault par votre widget de page par défaut
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: shareOnSocialMedia,
              child: Text("Partager sur les médias sociaux"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendMarketingEmail,
              child: Text("Envoyer un e-mail marketing"),
            ),
            // Vous pouvez ajouter ici d'autres fonctionnalités pour la gestion de site web et de boutique en ligne.
          ],
        ),
      ),
    );
  }
}
