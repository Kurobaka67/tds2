import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:tds2/screens/home_screen.dart';
import 'package:tds2/screens/login_screen.dart';

import 'firebase_options.dart';


ColorScheme theme = ColorScheme.fromSeed(seedColor: Colors.blue);

void onConnect(StompFrame frame) {
  stompClient.subscribe(
    destination: '/topic/test/subscription',
    callback: (frame) {
      List<dynamic>? result = json.decode(frame.body!);
      print(result);
    },
  );

  Timer.periodic(const Duration(seconds: 10), (_) {
    stompClient.send(
      destination: '/app/test/endpoints',
      body: json.encode({'a': 123}),
    );
  });
}

final stompClient = StompClient(
  config: StompConfig(
    url: 'ws://localhost:3000',
    onConnect: onConnect,
    beforeConnect: () async {
      print('waiting to connect...');
      await Future.delayed(const Duration(milliseconds: 200));
      print('connecting...');
    },
    onWebSocketError: (dynamic error) => print(error.toString()),
    stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
    webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  //stompClient.activate();

  var permissionGranted = true;
  if (Platform.isAndroid) {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      const permissionStorage = Permission.storage;
      final status = await permissionStorage.request();
      if (status.isGranted) {
        permissionGranted = true;
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else if (status.isDenied) {
        // Permission denied
        permissionGranted = false;
        print('Location permission denied.');
      }
    }
  }

  Widget screen = const LoginScreen();
  if(permissionGranted) {
    SharedPreferencesAsync? prefs = SharedPreferencesAsync();
    if (await prefs.getString('email') == null) {
      await prefs.setString('email', '');
    }
    String result = await prefs.getString('email') ?? '';
    if(result != ''){
      screen = const HomeScreen();
    }
  }
  runApp(MyApp(screen));
}

class MyApp extends StatelessWidget {
  final Widget screen;

  const MyApp(this.screen, {super.key,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TDS',
      theme: ThemeData(
        colorScheme: theme,
        useMaterial3: true,
      ),
      home: screen,
    );
  }
}