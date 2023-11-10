import 'package:fashion2/screen/clientHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../widgets/pageEnregistrementClient.dart';

class FirstTimeUserIntroduction extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    // Naviguez vers la page d'inscription du client après la fin de l'introduction.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ClientHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Bienvenue sur l'application Fashion2",
          body: "Découvrez comment vous pouvez utiliser notre application.",
          image: Center(
            child: Image.asset("assets/images/doctor1.jpg", width: 300),
          ),
        ),
        PageViewModel(
          title: "Inscrivez-vous en tant que client",
          body: "Remplissez les détails et commencez à explorer Fashion2.",
          image: Center(
            child: Image.asset("assets/images/doctor2.jpg", width: 300),
          ),
        ),
        PageViewModel(
          title: "Commencez votre aventure",
          body: "Trouvez les derniers vêtements et découvrez des mesures personnalisées.",
          image: Center(
            child: Image.asset("assets/images/doctor3.jpg", width: 300),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done"),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: const Size(20.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
