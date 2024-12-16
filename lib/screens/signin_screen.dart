import 'package:flutter/material.dart';

import '../widgets/signin_form.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
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
              image: const AssetImage("assets/images/bg_signin.png"),
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
                      height: 50,
                    ),
                    Text(
                      'Créer un compte !',
                      style: TextStyle(
                          color: theme.colorScheme.onPrimaryFixed,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 140,
                    ),
                    const Center(
                        child: SigninForm()
                    )
                  ],
                )),
          ))
    ]);
  }
}
