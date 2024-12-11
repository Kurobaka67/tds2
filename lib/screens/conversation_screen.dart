import 'package:flutter/material.dart';
import 'package:tds2/widgets/widgets.dart';

import '../models/user_model.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<UserModel> contacts = [
    UserModel(firstname: "Jon", lastname: "LEJEUNE", email: "Jon@gmail.com", role: 'client', hashPassword: "")
  ];
  late UserModel? contactValue = null;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        title: Center(child: Text('Conversations', style: TextStyle(color: theme.colorScheme.onPrimary),)),
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
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          FloatingActionButton(
            heroTag: "add_contact",
            onPressed: () {
              showAddConversation(context, theme);
            },
            child: const Icon(Icons.person_add_alt),
          ),
          const SizedBox(height: 10,),
          FloatingActionButton(
            heroTag: "add_conversation",
            onPressed: () {
              showAddContact(context, theme);
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: TopBarDrawer(title: "Contact", users: contacts),
      body: const Column(
        children: [
          TopBarMenu(),
          Text("conversation"),
        ],
      ),
    );
  }

  showAddContact(BuildContext context, ThemeData theme) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Annuler"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Ajouter"),
      onPressed:  () {

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Ajouté un contact"),
      content: const Text("Would you like to continue learning how to use Flutter alerts?"),
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

  showAddConversation(BuildContext context, ThemeData theme) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Annuler"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Créer"),
      onPressed:  () {

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      title: const Text("Créer une conversation"),
      content: Form(
        child: Column(
          children: [
            const Align(
                alignment: Alignment.topLeft,
                child: Text("Contact : ")
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 220,
                child: DropdownButton(
                  value: contactValue ?? contacts[0],
                  items: contacts.map((contact) {
                    return DropdownMenuItem<UserModel>(
                      value: contact,
                      child: Text(contact.firstname)
                    );
                  }).toList(),
                  onChanged: (UserModel? newValue) {
                    setState(() {
                      contactValue = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(),
            const Align(
                alignment: Alignment.topLeft,
                child: Text("Message : ")
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: TextField(
        
              ),
            )
          ],
        ),
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