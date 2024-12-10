import 'package:flutter/material.dart';
import 'package:tds2/screens/screens.dart';
import 'package:tds2/screens/signin_screen.dart';


ColorScheme theme = ColorScheme.fromSeed(seedColor: Colors.blue);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TDS',
      theme: ThemeData(
        colorScheme: theme,
        useMaterial3: true,
      ),
      home: const SigninScreen(),
    );
  }
}