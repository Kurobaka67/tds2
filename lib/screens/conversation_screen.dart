import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tds2/widgets/contact_item.dart';
import 'package:tds2/widgets/widgets.dart';

import '../models/user_model.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<UserModel> contacts = [
    UserModel(id: 2, firstname: "Jon", lastname: "LEJEUNE", email: "Jon@gmail.com", role: 'client', hashPassword: "")
  ];
  late UserModel? contactValue = null;

  @override
  void initState() {
    super.initState();
  }

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
      body: Column(
        children: [
          const TopBarMenu(),
          if(contacts!=null)
            SizedBox(
              height: 200,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.black,
                    indent: 20,
                    endIndent: 20,
                  ),
                  itemCount: contacts!.length,
                  itemBuilder: (context, index) => ContactItem(user: contacts![index])
              ),
            )
          else
            LoadingAnimationWidget.fourRotatingDots(
              size: 50,
              color: Colors.black45,
            ),
        /*Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final messages = snapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ListTile(
                          title: Text(message['text']),
                          subtitle: Text(
                            message['timestamp'].toDate().toString(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => _sendMessage(),
                    ),
                  ],
                ),
              ),
            ],
          ),*/
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