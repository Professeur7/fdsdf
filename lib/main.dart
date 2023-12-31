import 'package:fashion2/api/firebase_api.dart';
import 'package:fashion2/firebase_options.dart';
import 'package:fashion2/firestore.dart';
import 'package:fashion2/screen/loginSignupScreen.dart';
import 'package:fashion2/screen/notification_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

final navigatorkey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Nécessaire pour Firebase sur Flutter
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(
    GetMaterialApp(
      home: MyApp(),
    ),
  );
  // runApp(MultiProvider(
  //     providers: [ChangeNotifierProvider(create: (_) => FirebaseManagement())],
  //     child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Fashion',
      home: const LoginSignupScreen(),
      navigatorKey: navigatorkey,
      routes: {
        '/notificationScreen': (context) => const NotificationScreen(),
      },
    );
  }
}
