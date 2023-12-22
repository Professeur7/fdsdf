import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/config/palette.dart';
import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/client.dart';
import 'package:fashion2/models/tailleurs.dart';
import 'package:fashion2/screen/home_screen.dart';
import 'package:fashion2/widgets/atelierRegisterScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../widgets/pageEnregistrementClient.dart';
import 'clientHomeScreen.dart';
import 'introductionScreen.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isTailleur = false;
  //bool isClient = false;
  FirebaseManagement _management = Get.put(FirebaseManagement());
  bool isMale = true;
  bool isSignupScreen = false;
  bool isRememberMe = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userName = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference userRef =
      FirebaseFirestore.instance.collection("tailleurs");

  Future<void> login(BuildContext context, bool isLogin) async {
    try {
      // Vérification de la longueur du mot de passe
      if (password.text.length < 6) {
        Fluttertoast.showToast(
            msg: "Le mot de passe doit avoir au moins 6 caractères");
        Navigator.pop(context); // Fermer la boîte de dialogue
        return;
      }

      Future<void> registerUser(User) async {
        await _management.auth.value.createUserWithEmailAndPassword(
          email: User.email,
          password: User.password,
        );

        _management.auth.value.signInWithEmailAndPassword(
            email: User.email, password: User.password);

        print(User.runtimeType);
        userRef;
        User.runtimeType == Tailleurs
            ? {
                userRef = FirebaseFirestore.instance.collection("tailleurs"),
                _management.createTailleurs(User),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AtelierRegistrationPage()),
                )
              }
            : {
                userRef = FirebaseFirestore.instance.collection("Clients"),
                _management.createClient(User),
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClientRegistrationPage()))
              };

        //Future.delayed(Duration(seconds: 30));
        // Naviguer vers HomeScreen après l'inscription réussie
      }

      Future<void> loginUser(email, password) async {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        var listT = <Tailleurs>[];
        var listC = <Client>[];
        try {
          listT = await _management.getAllTailleurs();
        } catch (e) {
          print("errrrrrrrrrrrrr11111111111111111111111111111111");
        }

        try {
          listC = await _management.getAllClient();
        } catch (e) {
          print("errrrrrrrrrrrrroooooooooooooooooooooooo");
        }

        if (listT
            .where((element) =>
                element.email == email && element.password == password)
            .isNotEmpty) {
          _management.getTailleur(listT
              .where((element) =>
                  element.email == email && element.password == password)
              .first);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          _management.getClient(listC
              .where((element) =>
                  element.email == email && element.password == password)
              .first);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ClientHomeScreen()),
          );
        }
      }

      Future<bool> checkEmailExists(String email) async {
        try {
          final userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password:
                'dummyPassword', // You can use a dummy password for this check
          );

          // If the userCredential is not null, the email exists
          return userCredential != null;
        } catch (e) {
          // Handle any errors that may occur during the check
          print('Error checking email existence: $e');
          return false;
        }
      }

      //Commenting out email uniqueness check for registration
      if (!isLogin) {
        // Vérification de l'unicité de l'email
        bool emailExists = await checkEmailExists(email.text);
        if (emailExists) {
          Fluttertoast.showToast(
              msg: "Cet email est déjà utilisé par un autre utilisateur");
          Navigator.pop(context); // Fermer la boîte de dialogue
          return;
        }
      }

      if (!isLogin) {
        await loginUser(email.text, password.text);
      } else {
        String g = "";
        isMale == true ? g = "Homme" : g = "Femme";
        isTailleur == true
            ? await registerUser(Tailleurs(
                password: password.text,
                username: userName.text,
                email: email.text,
                genre: g))
            : registerUser(Client(
                username: userName.text,
                email: email.text,
                genre: g,
                password: password.text));
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: "Erreur d'authentification: ${e.message}");
      print("Firebase Error Code: ${e.code}"); // Print Firebase error code
    } catch (e) {
      Fluttertoast.showToast(msg: "Erreur inattendue: $e");
      print("Unexpected Error: $e"); // Print unexpected error
    } finally {
      //Navigator.pop(context); // Fermer la boîte de dialogue
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 90, left: 20),
                color: const Color(0xFF3b5999).withOpacity(.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: isSignupScreen ? "Bienvenue dans" : "Bienvenue",
                        style: TextStyle(
                          fontSize: 25,
                          letterSpacing: 2,
                          color: Colors.yellow[700],
                        ),
                        children: [
                          TextSpan(
                            text: isSignupScreen ? " Fashion, " : " Encore,",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      isSignupScreen
                          ? "Inscrivez-vous pour continuer"
                          : "Connectez-vous pour continuer",
                      style: const TextStyle(
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          buildBottomHalfContainer(true, isSignupScreen),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: isSignupScreen ? 200 : 230,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              height: isSignupScreen ? 380 : 270,
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SE CONNECTER",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: !isSignupScreen
                                      ? Palette.activeColor
                                      : Palette.textColor1,
                                ),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 100,
                                  color: Colors.orange,
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "S'INSCRIRE",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSignupScreen
                                      ? Palette.activeColor
                                      : Palette.textColor1,
                                ),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 100,
                                  color: Colors.orange,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isSignupScreen) buildScreenSection(),
                    if (!isSignupScreen) buildSigninSection(),
                  ],
                ),
              ),
            ),
          ),
          buildBottomHalfContainer(false, isSignupScreen),
          Positioned(
            top: MediaQuery.of(context).size.height - 100,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text(isSignupScreen
                    ? "Ou S'inscrire avec"
                    : "Ou Se connecter avec"),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildTextButton(MaterialCommunityIcons.facebook,
                          "Facebook", Palette.facebookColor),
                      buildTextButton(MaterialCommunityIcons.google_plus,
                          "Google", Palette.googleColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildSigninSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(
            Icons.mail_outline,
            "HamidouDjire@gmail.com",
            false,
            true,
            email,
          ),
          buildTextField(
            MaterialCommunityIcons.lock_outline,
            "*********",
            true,
            false,
            password,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isRememberMe,
                    activeColor: Palette.textColor2,
                    onChanged: (value) {
                      setState(() {
                        isRememberMe = !isRememberMe;
                      });
                    },
                  ),
                  const Text(
                    "Se souvenir de moi",
                    style: TextStyle(fontSize: 12, color: Palette.textColor1),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Oublie moi?",
                  style: TextStyle(fontSize: 12, color: Palette.textColor1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildScreenSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(
            MaterialCommunityIcons.account_outline,
            "Nom d'utilisateur",
            false,
            false,
            userName,
          ),
          buildTextField(
            MaterialCommunityIcons.email_outline,
            "email",
            false,
            false,
            email,
          ),
          buildTextField(
            MaterialCommunityIcons.lock_outline,
            "mot de passe",
            true,
            false,
            password,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isTailleur,
                    onChanged: (value) {
                      setState(() {
                        isTailleur = true;
                        //isClient = false;
                      });
                    },
                  ),
                  const Text(
                    "Tailleur",
                    style: TextStyle(color: Palette.textColor1),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: isTailleur,
                    onChanged: (value) {
                      setState(() {
                        //isClient = true;
                        isTailleur = false;
                      });
                    },
                  ),
                  const Text(
                    "Client",
                    style: TextStyle(color: Palette.textColor1),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = true;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              isMale ? Palette.textColor2 : Colors.transparent,
                          border: Border.all(
                            width: 1,
                            color: isMale
                                ? Colors.transparent
                                : Palette.textColor2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMale ? Colors.white : Palette.iconColor,
                        ),
                      ),
                      const Text(
                        "Homme",
                        style: TextStyle(color: Palette.textColor1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = false;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              isMale ? Colors.transparent : Palette.textColor2,
                          border: Border.all(
                            width: 1,
                            color: isMale
                                ? Palette.textColor1
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMale ? Palette.iconColor : Colors.white,
                        ),
                      ),
                      const Text(
                        "Femme",
                        style: TextStyle(color: Palette.textColor1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            margin: const EdgeInsets.only(top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: "En 'continuant' vous acceptez nos ",
                style: TextStyle(color: Palette.textColor2),
                children: [
                  TextSpan(
                    //recognizer: ,
                    text: "termes & conditions",
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(width: 1, color: Colors.grey),
        minimumSize: const Size(145, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: backgroundColor,
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 5,
          ),
          Text(title),
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow, bool isSignupScreen) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 535 : 450,
      right: 0,
      left: 0,
      child: Center(
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16.0),
                      Text(isSignupScreen
                          ? 'Inscription en cours...'
                          : 'Connexion en cours...'),
                    ],
                  ),
                );
              },
            );
            login(context, isSignupScreen);
          },
          child: Container(
            height: 90,
            width: 90,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
              ],
            ),
            child: !showShadow
                ? Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.orange, Colors.red],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  )
                : const Center(),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail, TextEditingController text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: text,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
      ),
    );
  }
}
