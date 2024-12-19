import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tds2/models/group_model.dart';
import 'package:tds2/models/message_model.dart';
import 'package:tds2/models/user_model.dart';
import 'package:tds2/services/messages_services.dart';
import 'package:tds2/services/users_services.dart';
import 'package:tds2/widgets/widgets.dart';

import '../services/groups_services.dart';

class MessageScreen extends StatefulWidget {
  final GroupModel group;

  const MessageScreen({
    super.key,
    required this.group
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<UserModel> users = [
    UserModel(id: 1, firstname: "Jonathan", lastname: "GRILL", email: "Jonathan@gmail.com", role: 'client', hashPassword: ""),
    UserModel(id: 2, firstname: "Jon", lastname: "LEJEUNE", email: "Jon@gmail.com", role: 'client', hashPassword: "")
  ];
  List<UserModel>? users2;
  List<MessageModel> messages = [];
  List<MessageModel>? messages2;
  TextEditingController newMessageController = TextEditingController();
  String newMessage = "";

  bool isLoading = false;

  Future<void> initUsers() async {
    setState(() {
      isLoading = true;
    });
    users2 = (await UsersService().getUserByGroup(widget.group.id));
    setState(() {
      isLoading = true;
    });
    initMessage();
  }

  Future<void> initMessage() async {
    setState(() {
      isLoading = true;
    });
    messages2 = (await MessageService().getAllMessagesByGroup(widget.group.id));
    print(messages2);
    setState(() {
      isLoading = true;
    });
  }

  Future<void> initFirebase() async {
    FirebaseMessaging.instance
        .getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      setState(() {
        messages.add(MessageModel(user: users[1], content: message.notification!.body!, date: DateTime.now()));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    messages = [
      MessageModel(user: users[0], content: "Bonjour", date: DateTime.now()),
      MessageModel(user: users[1], content: "Salut", date: DateTime.now()),
      MessageModel(user: users[0], content: "Ca va ?", date: DateTime.now())
    ];
    initUsers();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        title: Center(child: Text(widget.group.name, style: TextStyle(color: theme.colorScheme.onPrimary),)),
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
      drawer: TopBarDrawer(title: "Utilisateurs du groupe", users: users2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBarMenu(),
            SizedBox(
              height: 580,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  for(var message in messages)
                    MessageItem(message: message, type: message.user?.firstname=="Jonathan"?"sent":"received")
                ],
              ),
            ),
            SizedBox(
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              elevation: 0,
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                            onPressed: () {

                            },
                            child: const Icon(Icons.attach_file)
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          controller: newMessageController,
                          decoration: InputDecoration(
                              fillColor: theme.colorScheme.primary.withOpacity(0.3),
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(16))
                              )
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              elevation: 0,
                              backgroundColor: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                            onPressed: () {

                            },
                            child: const Icon(Icons.send)
                        ),
                      )
                    ],
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}