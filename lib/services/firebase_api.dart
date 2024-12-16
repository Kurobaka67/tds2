import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage? message) async {
  print('Title : ${message?.notification?.title}');
  print('Body : ${message?.notification?.body}');
  print('Payload : ${message?.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> init() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    //print('Token : $fCMToken'); //Change this to save in database
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    return fCMToken;
  }
}