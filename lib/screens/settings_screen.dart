import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/services/users_services.dart';
import 'package:tds2/widgets/widgets.dart';

import 'home_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> initializeSharedPreferences() async {
    setState(() {
    });
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        title: Center(child: Text('Options', style: TextStyle(color: theme.colorScheme.onPrimary),)),
        backgroundColor: theme.colorScheme.primary,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: SizedBox(
              width: 40,
              child: OptionsMenu(),
            ),
          )
        ],
      ),
      drawer: const TopBarDrawer(title: ""),
      body: Column(
        children: [
          const TopBarMenu(),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      const SizedBox(
                        height: 130,
                        width: 130,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage("https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg"),
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(75)
                        ),
                        child: IconButton(
                            onPressed: () {

                            },
                            icon: const Icon(Icons.mode_edit, size: 30, color: Colors.white)
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                      controller: firstnameController,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.account_circle_rounded,
                            color: theme.colorScheme.onSurface,
                            size: 30,
                          ),
                        ),
                      )
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                      controller: lastnameController,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.account_circle_rounded,
                            color: theme.colorScheme.onSurface,
                            size: 30,
                          ),
                        ),
                      )
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                      controller: emailController,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.email_outlined,
                            color: theme.colorScheme.onSurface,
                            size: 30,
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}