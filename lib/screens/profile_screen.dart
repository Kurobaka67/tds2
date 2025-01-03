import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/models/user_model.dart';
import 'package:tds2/services/users_services.dart';
import 'package:tds2/widgets/widgets.dart';

import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String email = '';
  String firstname = '';
  String lastname = '';
  String password = '';
  String? pictureBase64String;
  File? selectedImage;
  final picker = ImagePicker();

  Future<void> initializeSharedPreferences() async {
    final String fn = await prefs?.getString('firstname') ?? '';
    final String ln = await prefs?.getString('lastname') ?? '';
    final String em = await prefs?.getString('email') ?? '';
    final String pw = await prefs?.getString('password') ?? '';

    String? pic;
    var r = await prefs?.getString('picture');
    if(r != null && r.isNotEmpty){
      pic = await prefs?.getString('picture');
    }

    setState(() {
      email = em;
      firstname = fn;
      lastname = ln;
      password = pw;
      pictureBase64String = pic;
      firstnameController.text = fn;
      lastnameController.text = ln;
      passwordController.text = pw;
    });
  }

  Future<void> pickImageFromGallery() async {
    final returnedImage = await picker.pickImage(source: ImageSource.gallery);

    if(returnedImage == null) return;

    setState(() {
      selectedImage = File(returnedImage.path);
    });
    var _bytes = (await selectedImage?.readAsBytes());
    setState(() {
      pictureBase64String = base64.encode(_bytes as List<int>);
    });
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  Future<void> editProfile() async {
    setState(() {
      isLoading = true;
    });
    if(firstname != firstnameController.text || lastname != lastnameController.text || selectedImage != null){
      setState(() {
        firstname = firstnameController.text;
        lastname = lastnameController.text;
      });
      bool result = (await UsersService().editUser(firstname, lastname, email, pictureBase64String));

      List<UserModel>? u = (await UsersService().getUserByEmail( email ));

      if(result && u != null){
        await prefs?.setString('email', u[0].email);
        await prefs?.setString('firstname', u[0].firstname);
        await prefs?.setString('lastname', u[0].lastname);
        await prefs?.setString('role', u[0].role);
        await prefs?.setString('password', u[0].hashPassword);
        if(u[0].pictureEncoded != null){
          String p = u[0].pictureEncoded as String;
          await prefs?.setString('picture', p);
        }
        _navigateToHomeScreen(context);
      }
    }
    setState(() {
      isLoading = false;
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

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        title: Center(child: Text('Profile édition', style: TextStyle(color: theme.colorScheme.onPrimary),)),
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
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: CircleAvatar(
                          backgroundImage: selectedImage != null?FileImage(selectedImage!): pictureBase64String != null?MemoryImage(base64Decode(pictureBase64String!)):const NetworkImage("https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg"),
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
                              pickImageFromGallery();
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
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            width: 160,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(theme.colorScheme.secondary),
              ),
              onPressed: () {
                editProfile();
              },
              child: Row(
                children: [
                  Text("Modifié", style: TextStyle(fontSize: 24, color: theme.colorScheme.onSecondary)),
                  const Spacer(),
                  Icon(Icons.mode_edit, color: theme.colorScheme.onSecondary)
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}