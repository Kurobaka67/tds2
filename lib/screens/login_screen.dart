import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                      height: 100,
                    ),
                    const Center(
                        child: LoginForm()
                    )
                  ],
                )),
          ))
    ]);
  }
}
