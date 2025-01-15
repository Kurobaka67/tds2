import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/screens.dart';

import '../logger.dart';
import '../services/users_services.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  bool isLoading = false;

  String email = '';
  String firstname = '';
  String lastname = '';
  String password = '';
  String passwordConfirm = '';

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> createAccount() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      email = emailController.text.toLowerCase();
      firstname = firstnameController.text;
      lastname = lastnameController.text;
      password = passwordController.text;
      passwordConfirm = passwordConfirmController.text;
      isLoading = false;
    });
    bool result = false;
    if (password == passwordConfirm) {
      result =
      (await UsersService().signin(firstname, lastname, email, password));
    }

    if(result){
      emailController.clear();
      firstnameController.clear();
      lastnameController.clear();
      passwordController.clear();
      passwordConfirmController.clear();

      _navigateToLoginScreen(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final signinFormKey = GlobalKey<FormState>();

    return Form(
      key: signinFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextFormField(
                focusNode: myFocusNode,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  SystemChrome.restoreSystemUIOverlays();
                },
                keyboardType: TextInputType.name,
                autofillHints: const <String>[AutofillHints.name],
                controller: firstnameController,
                validator:
                MinLengthValidator(1, errorText: 'Veuillez remplir ce champ').call,
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
                  hintText: 'Prénom',
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  SystemChrome.restoreSystemUIOverlays();
                },
                keyboardType: TextInputType.name,
                autofillHints: const <String>[AutofillHints.familyName],
                controller: lastnameController,
                validator:
                MinLengthValidator(1, errorText: 'Veuillez remplir ce champ').call,
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
                  hintText: 'Nom',
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextFormField(
                textInputAction: TextInputAction.next,
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextFormField(
                textInputAction: TextInputAction.next,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  SystemChrome.restoreSystemUIOverlays();
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordConfirmController,
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
                  hintText: 'Confirme mot de passe',
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
            const SizedBox(height: 30),
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      _navigateToLoginScreen(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      fixedSize: const Size(130, 50),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Retour',
                          style: TextStyle(
                            color: theme.colorScheme.onSecondary,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    )
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      if (signinFormKey.currentState!.validate()) {
                        createAccount();
                        logger.i('Compte créé');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      fixedSize: const Size(160, 50),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Valider',
                          style: TextStyle(
                            color: theme.colorScheme.onSecondary,
                            fontSize: 25,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward, color: theme.colorScheme.onSecondary)
                      ],
                    )
                ),
                const Spacer(),
              ],
            ),
          ]
      ),
    );
  }
}