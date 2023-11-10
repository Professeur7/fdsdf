import 'package:fashion2/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  //create an int=stance of firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  //function to initialize notifications
  Future<void> initNotifications() async {
    //request permission for user(will prompt user)
    await _firebaseMessaging.requestPermission();

    //fetch the FCM token for this devise
    final fCMToken = await _firebaseMessaging.getToken();

    // ignore: avoid_print
    print('Token: $fCMToken');

    //initilize further settings for push noti
    initPushNotifications();
  }

  //function to handle received messages
  void handleMessage(RemoteMessage? message) {
    //if the message is null, do nothing
    if (message == null) return;

    //navigate to new screen when message is receveid and user taps notifaications
    navigatorkey.currentState?.pushNamed(
      '/notificationScreen',
      arguments: message,
    );
  }

  //function to initialize background settings
  Future initPushNotifications() async {
    //handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    //attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
