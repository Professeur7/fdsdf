import 'package:fashion2/screen/loginSignupScreen.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Utiliser Future.delayed pour simuler un délai avant la navigation
    Future.delayed(Duration(seconds: 5), () {
      // Naviguer vers la page principale (HomePage par exemple)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginSignupScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFF09126C),
      body: Center(
        child: Image.asset(
          'assets/images/Fashion.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}