import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tds2/models/group_model.dart';
import 'package:tds2/models/message_model.dart';
import 'package:tds2/models/user_model.dart';
import 'package:tds2/services/messages_services.dart';
import 'package:tds2/services/users_services.dart';
import 'package:tds2/widgets/widgets.dart';

import '../services/groups_services.dart';

class GroupMessageScreen extends StatefulWidget {
  final GroupModel group;

  const GroupMessageScreen({
    super.key,
    required this.group
  });

  @override
  State<GroupMessageScreen> createState() => _GroupMessageScreenState();
}

class _GroupMessageScreenState extends State<GroupMessageScreen> {
  List<UserModel> users = [
    UserModel(id: 1, firstname: "Jonathan", lastname: "GRILL", email: "Jonathan@gmail.com", role: 'client', hashPassword: ""),
    UserModel(id: 2, firstname: "Jon", lastname: "LEJEUNE", email: "Jon@gmail.com", role: 'client', hashPassword: "")
  ];
  List<UserModel>? users2;
  List<MessageModel> messages = [];
  List<MessageModel> messages2 = [];
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
    List<MessageModel>? result = (await MessageService().getAllMessagesByGroup(widget.group.id));
    if(result != null){
      setState(() {
        messages2 = result;
      });
    }
    setState(() {
      isLoading = true;
    });
  }

  Future<void> initFirebase() async {
    FirebaseMessaging.instance
        .getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      setState(() {
        messages2.add(MessageModel(user: users.firstWhere((element) => element.id == int.parse(message.data.values.first)), content: message.notification!.body!, date: DateTime.now()));
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
                  for(var message in messages2)
                    MessageItem(message: message, type: message.user?.firstname=="Jonathan"?"sent":"received")
                ],
              ),
            ),
            NewMessageTextField(group: widget.group, messages: messages2,)
          ],
        ),
      ),
    );
  }
}