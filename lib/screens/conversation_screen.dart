import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/models/contact_model.dart';
import 'package:tds2/widgets/contact_item.dart';
import 'package:tds2/widgets/widgets.dart';

import '../models/user_model.dart';
import '../services/contacts_services.dart';
import '../services/users_services.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  List<UserModel> contacts = [
    UserModel(id: 2, firstname: "Jon", lastname: "LEJEUNE", email: "Jon@gmail.com", role: 'client', hashPassword: "")
  ];
  List<ContactModel>? contacts2;
  UserModel? user;
  late UserModel? contactValue = null;
  TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  Future<void> initUser() async {
    var email = await prefs?.getString('email') ?? '';
    setState(() {
      isLoading = true;
    });
    List<UserModel>? result = (await UsersService().getUserByEmail(email));
    if(result != null){
      setState(() {
        user = result[0];
      });
    }
    setState(() {
      isLoading = true;
    });
    initContact();
  }

  Future<void> initContact() async {
    setState(() {
      isLoading = true;
    });
    List<ContactModel>? result;
    if(user != null )result = (await ContactsServices().getContactsByUser(user!.id));
    if(result != null){
      setState(() {
        contacts2 = result!;
      });
    }
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initContact();
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
      drawer: TopBarDrawer(title: "Contact", contacts: contacts),
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
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            const Text("Entrer l'adresse mail de la personne que vous voulez ajouter en ami."),
            TextFormField(
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
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(15),
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
          ]
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
        child: SizedBox(
          height: 300,
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