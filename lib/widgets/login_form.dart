import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/models/user_model.dart';
import '../screens/screens.dart';

import '../logger.dart';
import '../services/users_services.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  bool isLoading = false;

  String email = '';
  String password = '';

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
      email = emailController.text.toLowerCase();
      password = passwordController.text;
      isLoading = false;
    });
    List<UserModel>? result = (await UsersService().login(email, password));

    emailController.clear();
    passwordController.clear();
    if(result != null) {
      await prefs?.setString('email', result[0].email);
      await prefs?.setString('firstname', result[0].firstname);
      await prefs?.setString('lastname', result[0].lastname);
      await prefs?.setString('role', result[0].role);
      await prefs?.setString('password', result[0].hashPassword);
      if(result[0].pictureEncoded != null){
        String p = result[0].pictureEncoded as String;
        await prefs?.setString('picture', p);
      }
      _navigateToHomeScreen(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final loginFormKey = GlobalKey<FormState>();

    return Form(
      key: loginFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: TextFormField(
                focusNode: myFocusNode,
                onEditingComplete: () {
                  SystemChrome.restoreSystemUIOverlays();
                },
                keyboardType: TextInputType.emailAddress,
                autofillHints: const <String>[AutofillHints.email],
                controller: emailController,
                validator:
                  EmailValidator(errorText: 'Veuillez entrer un email').call,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),

                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Email',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.mail_outline,
                      color: theme.colorScheme.onSurface,
                      size: 30,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 20,
                  ),
                  errorStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: TextFormField(
                onEditingComplete: () {
                  SystemChrome.restoreSystemUIOverlays();
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordController,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),

                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Mot de passe',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.key,
                      color: theme.colorScheme.onSurface,
                      size: 30,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 20,
                  ),
                  errorStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  if (loginFormKey.currentState!.validate()) {
                    loginUser();
                    //logger.i('Connexion');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  fixedSize: Size(isLoading?210:175, 50),
                ),
                child: Row(
                  children: [
                    Text(
                      'Connexion',
                      style: TextStyle(
                        color: theme.colorScheme.onSecondary,
                        fontSize: 25,
                      ),
                    ),
                  ],
                )
            ),
          ]
      ),
    );
  }
}