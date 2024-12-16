import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/screens/signin_screen.dart';
import 'package:tds2/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //SharedPreferencesAsync? prefs = SharedPreferencesAsync();

  Future<void> initializeSharedPreferences() async {

  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Stack(children: [
      Container(
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/bg_login.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(theme.colorScheme.primaryFixed, BlendMode.modulate)
          ),
        ),
      ),
      Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
            child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 100,
                      width: 250,
                      child:
                      Image.asset('assets/images/logoTDS.png', fit: BoxFit.cover),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Bienvenue !',
                      style: TextStyle(
                          color: theme.colorScheme.onPrimaryFixed,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 120,
                    ),
                    const Center(
                        child: LoginForm()
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
                            _navigateToSigninScreen(context);
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
                  ],
                )),
          ))
    ]);
  }

  void _navigateToSigninScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SigninScreen()));
  }
}
