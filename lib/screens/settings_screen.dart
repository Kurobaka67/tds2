import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/models/user_model.dart';
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
  UserModel? user;
  bool? isNotif = true;
  String themeSelected = "Clair";
  List<String> themes = [
    "Clair",
    "Sombre"
  ];

  bool isLoading = false;

  Future<void> initUser() async {
    var email = await prefs?.getString('email') ?? '';
    List<UserModel>? result = (await UsersService().getUserByEmail(email));
    setState(() {
      if(result != null)user = result[0];
    });
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  Future<bool> showDialogConfirm() async {
    return false;
  }

  Future<void> showDialogAccountDeleted() async {

  }

  Future<void> deleteAccount() async {
    bool isConfirm = await showDialogConfirm();
    setState(() {
      isLoading = true;
    });
    bool result = false;
    if(user != null )result = (await UsersService().deleteAccount(user!.id));
    if(result == true){
      setState(() {
        showDialogAccountDeleted();
      });
    }
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initUser();
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
                  CheckboxListTile(
                    title: const Row(
                      children: [
                        Text("Notification"),
                        Icon(Icons.notifications)
                      ],
                    ),
                    value: isNotif,
                    onChanged: (newValue) {
                      setState(() {
                        isNotif = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  ),
                  const SizedBox(
                    height: 20,
                    child: Divider(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          const Text('theme'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: DropdownButton(
                              value: themeSelected,
                              items: themes.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  themeSelected = newValue!;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}