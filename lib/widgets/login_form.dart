import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logger.dart';
import '../services/users_services.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  bool isLoading = false;

  String email = '';
  String password = '';

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      email = emailController.text.toLowerCase();
      password = passwordController.text;
      isLoading = false;
    });
    Widget? screen = (await UsersService().login(email, password));

    emailController.clear();
    passwordController.clear();
    if(screen != null) {
      //goToScreen(screen);
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
                      Icons.account_circle_rounded,
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
                    logger.i('Connexion');
                    //_navigateToNextScreen(context);
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
            const SizedBox(height: 20),
            Stack(
              children: [
                Divider(
                  endIndent: 30,
                  indent: 30,
                  thickness: 2,
                  color: theme.colorScheme.onSurface,
                ),
                Center(
                    child: Container(
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1E4FF)
                      ),
                      child: const Center(child: Text('OU', style: TextStyle(fontSize: 18)))
                    )
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  if (loginFormKey.currentState!.validate()) {
                    loginUser();
                    logger.i('Connexion');
                    //_navigateToNextScreen(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  fixedSize: Size(240, 50),
                ),
                child: Row(
                  children: [
                    Text(
                      'Créer un compte',
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