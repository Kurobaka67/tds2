import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/screens/home_screen.dart';
import 'package:tds2/screens/login_screen.dart';


ColorScheme theme = ColorScheme.fromSeed(seedColor: Colors.blue);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //await Firebase.initializeApp();

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