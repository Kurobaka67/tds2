import 'package:flutter/material.dart';
import 'package:tds2/models/group_model.dart';
import 'package:tds2/widgets/widgets.dart';

import '../models/user_model.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  late List<GroupModel>? groups = [
    GroupModel(name: "test", moderator: UserModel(firstname: "Jonathan", lastname: "GRILL", email: "Jonathan@gmail.com", isAdmin: false)),
    GroupModel(name: "test2", moderator: UserModel(firstname: "Jon", lastname: "LEJEUNE", email: "Jon@gmail.com", isAdmin: false))
  ];

  @override
  void initState() {
    super.initState();
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddNewGroup(context, theme);
        },
        child: const Icon(Icons.group_add),
      ),
      drawer: TopBarDrawer(title: "Groupes",groups: groups , user: UserModel(firstname: "Jonathan", lastname: "GRILL", email: "Jonathan@gmail.com", isAdmin: false)),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const TopBarMenu(),
            SizedBox(
              height: 200,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.black,
                    indent: 20,
                    endIndent: 20,
                  ),
                  itemCount: groups!.length,
                  itemBuilder: (context, index) => GroupItem(group: groups![index])
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAddNewGroup(BuildContext context, ThemeData theme) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Annuler"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Rejoindre"),
      onPressed:  () {

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Rejoindre un groupe"),
      content: const Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text("Code du groupe : ")
            ),
            TextField()
          ]
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}