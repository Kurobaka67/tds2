import 'package:flutter/material.dart';
import 'package:tds2/models/group_model.dart';
import 'package:tds2/models/message_model.dart';
import 'package:tds2/models/user_model.dart';
import 'package:tds2/widgets/widgets.dart';

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
    UserModel(firstname: "Jonathan", lastname: "GRILL", email: "Jonathan@gmail.com", role: 'client'),
    UserModel(firstname: "Jon", lastname: "LEJEUNE", email: "Jon@gmail.com", role: 'client')
  ];
  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    messages = [
      MessageModel(user: users[0], content: "Bonjour", date: DateTime.now()),
      MessageModel(user: users[1], content: "Salut", date: DateTime.now()),
      MessageModel(user: users[0], content: "Ca va ?", date: DateTime.now())
    ];
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
        title: Center(child: Text(widget.group.name)),
      ),
      drawer: TopBarDrawer(title: "Utilisateurs du groupe", users: users, user: UserModel(firstname: "Jonathan", lastname: "GRILL", email: "Jonathan@gmail.com", role: 'client')),
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
                    MessageItem(message: message, type: message.user.firstname=="Jonathan"?"sent":"received")
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