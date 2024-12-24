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
  final UserModel receiver;

  const MessageScreen({
    super.key,
    required this.receiver
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<MessageModel> messages = [];
  List<MessageModel>? messages2;
  TextEditingController newMessageController = TextEditingController();
  String newMessage = "";

  bool isLoading = false;

  Future<void> initMessage() async {
    setState(() {
      isLoading = true;
    });
    messages2 = (await MessageService().getMessageByUser(widget.receiver.id));
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
        //messages.add(MessageModel(user: users[1], content: message.notification!.body!, date: DateTime.now()));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        title: Center(child: Text(widget.receiver.firstname, style: TextStyle(color: theme.colorScheme.onPrimary),)),
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
      drawer: const TopBarDrawer(title: "Conversation"),
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