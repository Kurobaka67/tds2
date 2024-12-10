import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/screens/login_screen.dart';

import '../models/user_model.dart';
import '../services/users_services.dart';
class OptionsMenu extends StatefulWidget {
  const OptionsMenu({super.key});

  @override
  State<OptionsMenu> createState() => _OptionsMenuState();
}

class _OptionsMenuState extends State<OptionsMenu> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  String email = "";

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> logout() async {
    bool result = (await UsersService().logout(email));
    if(result){
      await prefs?.setString('email', '');
      await prefs?.setString('firstname', '');
      await prefs?.setString('lastname', '');
      await prefs?.setString('role', '');
      _navigateToLoginScreen(context);
    }
  }

  Future<void> initializeSharedPreferences() async {
    final String em = await prefs?.getString('email') ?? '';
    setState(() {
      email = em;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return MenuAnchor(
        builder: (BuildContext context, MenuController controller,
            Widget? child) {
          return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: theme.colorScheme.onPrimary,
            ),
            tooltip: 'Options',
          );
        },
        menuChildren: [
          MenuItemButton(
            onPressed: () {

            },
            child: const Row(
              children: [
                Text("Options"),
                Spacer(),
                Icon(Icons.settings),
              ],
            ),
          ),
          MenuItemButton(
            onPressed: () {
              logout();
            },
            child: const Row(
              children: [
                Text("Déconnexion"),
                Spacer(),
                Icon(Icons.output),
              ],
            ),
          )
        ]
    );
  }
}