// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCZwyRLV9P1T9N2vJltKiRZS7sYruJBcXs',
    appId: '1:488146842626:web:ff285ad68a6c59b566a31b',
    messagingSenderId: '488146842626',
    projectId: 'fashion-mobile-mode',
    authDomain: 'fashion-mobile-mode.firebaseapp.com',
    databaseURL: 'https://fashion-mobile-mode-default-rtdb.firebaseio.com',
    storageBucket: 'fashion-mobile-mode.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCv7h61j0Lv6gKLZSQATdR6erEnc4VhqkE',
    appId: '1:488146842626:android:4e08029c40c1d42266a31b',
    messagingSenderId: '488146842626',
    projectId: 'fashion-mobile-mode',
    databaseURL: 'https://fashion-mobile-mode-default-rtdb.firebaseio.com',
    storageBucket: 'fashion-mobile-mode.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAN1xQI9mKTZnG_yaYRCqfYVLynM4qveTs',
    appId: '1:488146842626:ios:fe4de2a4597176f266a31b',
    messagingSenderId: '488146842626',
    projectId: 'fashion-mobile-mode',
    databaseURL: 'https://fashion-mobile-mode-default-rtdb.firebaseio.com',
    storageBucket: 'fashion-mobile-mode.appspot.com',
    iosBundleId: 'com.example.fashion2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAN1xQI9mKTZnG_yaYRCqfYVLynM4qveTs',
    appId: '1:488146842626:ios:1fc0b1fbd857475966a31b',
    messagingSenderId: '488146842626',
    projectId: 'fashion-mobile-mode',
    databaseURL: 'https://fashion-mobile-mode-default-rtdb.firebaseio.com',
    storageBucket: 'fashion-mobile-mode.appspot.com',
    iosBundleId: 'com.example.fashion2.RunnerTests',
  );
}
