import 'package:flutter/material.dart';
import 'package:tds2/widgets/widgets.dart';

import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
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
      drawer: TopBarDrawer(title: "", user: UserModel(firstname: "Jonathan", lastname: "GRILL", email: "Jonathan@gmail.com", role: 'client')),
      body: const Column(
        children: [
          TopBarMenu(),
          Text("Home"),
        ],
      ),
    );
  }
}