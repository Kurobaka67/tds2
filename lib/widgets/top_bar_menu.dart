import 'package:flutter/material.dart';
import 'package:tds2/screens/screens.dart';

class TopBarMenu extends StatefulWidget {
  const TopBarMenu({super.key});

  @override
  State<TopBarMenu> createState() => _TopBarMenuState();
}

class _TopBarMenuState extends State<TopBarMenu> {

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SizedBox(
      height: 70,
      child: Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                  fixedSize: Size(MediaQuery.of(context).size.width/3, 70),
                ),
                child: Icon(Icons.home, color: theme.colorScheme.onSecondary)
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GroupScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                  fixedSize: Size(MediaQuery.of(context).size.width/3, 70),
                ),
                child: Icon(Icons.people_alt, color: theme.colorScheme.onSecondary),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ConversationScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                  fixedSize: Size(MediaQuery.of(context).size.width/3, 70),
                ),
                child: Icon(Icons.message, color: theme.colorScheme.onSecondary),
            ),
          ]
      ),
    );
  }
}