import 'package:flutter/material.dart';
import 'package:tds2/widgets/widgets.dart';

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
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        title: Center(
            child: Text(
          'Accueil',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        )),
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
            height: 300,
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Jonathan'),
                  subtitle: Text('Dernier message: Bonjour, comment allez-vous?'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Jo'),
                  subtitle: Text('Dernier message: Merci pour votre réponse.'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
