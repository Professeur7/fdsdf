import 'package:fashion2/api/firebase_api.dart';
import 'package:fashion2/firebase_options.dart';
import 'package:fashion2/widgets/splashPage.dart';
import 'package:fashion2/screen/notification_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Fashion',
      home: SplashPage(),
      navigatorKey: navigatorkey,
      routes: {
        '/notificationScreen': (context) => const NotificationScreen(),
      },
    );
  }
}
