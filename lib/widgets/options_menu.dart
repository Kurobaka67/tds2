import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/screens.dart';
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

  void _navigateToOptionsScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SettingScreen()));
  }

  Future<void> logout() async {
    bool result = (await UsersService().logout(email));
    if(result){
      await prefs?.setInt('id', -1);
      await prefs?.setString('email', '');
      await prefs?.setString('firstname', '');
      await prefs?.setString('lastname', '');
      await prefs?.setString('role', '');
      await prefs?.setString('picture', '');
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
              _navigateToOptionsScreen(context);
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