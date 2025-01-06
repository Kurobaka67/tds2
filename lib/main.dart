import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/screens/screens.dart';

import 'firebase_options.dart';
import 'package:tds2/my_globals.dart' as globals;

ColorScheme lightTheme = ColorScheme.fromSeed(seedColor: Colors.blue,
  primary: const Color(0xFF0056B3),
  onPrimary: const Color(0xFFECF0F1),
  secondary: const Color(0xFF648DB5),
  onSecondary: const Color(0xFFBDC3C7),
  surface: const Color(0xFFE0F0FF),
  primaryFixed: const Color(0xFFCDE3F7),
  onPrimaryFixed: const Color(0xFF2C3E50)
);

ColorScheme darkTheme = ColorScheme.fromSeed(seedColor: Colors.blue,
  primary: const Color(0xFF2C3E50),
  onPrimary: const Color(0xFFE0E0E0),
  secondary: const Color(0xFF2E3B4E),
  onSecondary: const Color(0xFFC0C0C0),
  surface: const Color(0xFF121212),
  primaryFixed: const Color(0xFF2C2C2C),
  onPrimaryFixed: const Color(0xFFF5F5F5)
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

    /*FirebaseMessaging.instance
        .getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      await prefs.setString('notif', message.notification!.title!);
      print(message.notification?.title);
    });*/
  }
  else{
    print('Storage permission denied.');
    exit(0);
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
        colorScheme: lightTheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkTheme,
        useMaterial3: true,
      ),
      themeMode: globals.themeMode,
      home: screen,
    );
  }
}

class ErrorHandlerWidget extends StatefulWidget {
  final Widget child;

  ErrorHandlerWidget({required this.child});

  @override
  _ErrorHandlerWidgetState createState() => _ErrorHandlerWidgetState();
}

class _ErrorHandlerWidgetState extends State<ErrorHandlerWidget> {
  // Error handling logic
  void onError(FlutterErrorDetails errorDetails) {
    // Add your error handling logic here, e.g., logging, reporting to a server, etc.
    print('Caught error: ${errorDetails.exception}');
  }

  @override
  Widget build(BuildContext context) {
    return ErrorWidgetBuilder(
      builder: (context, errorDetails) {
        // Display a user-friendly error screen
        return Scaffold(
          appBar: AppBar(title: Text('Error')),
          body: Center(
            child: Text('Something went wrong. Please try again later.'),
          ),
        );
      },
      onError: onError,
      child: widget.child,
    );
  }
}

class ErrorWidgetBuilder extends StatefulWidget {
  final Widget Function(BuildContext, FlutterErrorDetails) builder;
  final void Function(FlutterErrorDetails) onError;
  final Widget child;

  ErrorWidgetBuilder({
    required this.builder,
    required this.onError,
    required this.child,
  });

  @override
  _ErrorWidgetBuilderState createState() => _ErrorWidgetBuilderState();
}

class _ErrorWidgetBuilderState extends State<ErrorWidgetBuilder> {
  @override
  void initState() {
    super.initState();
    // Set up global error handling
    FlutterError.onError = widget.onError;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}