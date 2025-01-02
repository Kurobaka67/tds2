import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/models/group_model.dart';
import 'package:tds2/models/message_model.dart';
import 'package:tds2/models/user_model.dart';
import 'package:tds2/services/messages_services.dart';
import 'package:tds2/services/users_services.dart';
import 'package:tds2/widgets/widgets.dart';

class PrivateMessageScreen extends StatefulWidget {
  final UserModel receiver;

  const PrivateMessageScreen({
    super.key,
    required this.receiver
  });

  @override
  State<PrivateMessageScreen> createState() => _PrivateMessageScreenState();
}

class _PrivateMessageScreenState extends State<PrivateMessageScreen> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  UserModel? user;
  List<MessageModel> messages = [];
  TextEditingController newMessageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String newMessage = "";

  bool isLoading = false;

  Future<void> initUser() async {
    setState(() {
      isLoading = true;
    });
    final String email = await prefs?.getString('email') ?? '';
    List<UserModel>? result;
    if(user != null )result = (await UsersService().getUserByEmail(email));
    if(result != null){
      setState(() {
        user = result![0];
      });
    }
    setState(() {
      isLoading = true;
    });
  }

  Future<void> initMessage() async {
    setState(() {
      isLoading = true;
    });
    List<MessageModel>? result;
    if(user != null )result = (await MessageService().getPrivateMessage(user!.id, widget.receiver.id));
    if(result != null){
      setState(() {
        messages = result!;
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
        messages.add(MessageModel(user: widget.receiver, content: message.notification!.body!, date: DateTime.now()));
      });
    });
  }

  void callback(MessageModel message) {
    print('hey');
    setState(() {
      messages.add(message);
    });
  }

  void scrollDown() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    messages = [
      MessageModel(user: widget.receiver, content: "Bonjour", date: DateTime.now()),
      MessageModel(user: user, content: "Salut", date: DateTime.now()),
      MessageModel(user: widget.receiver, content: "Ca va ?", date: DateTime.now())
    ];
    initUser();
    initFirebase();
  }

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final FocusNode _nodeText6 = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(focusNode: _nodeText2, toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
        KeyboardActionsItem(
          focusNode: _nodeText3,
          onTapAction: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text("Custom Action"),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text("OK"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
                });
          },
        ),
        KeyboardActionsItem(
          focusNode: _nodeText4,
        ),
        KeyboardActionsItem(
          focusNode: _nodeText5,
          toolbarButtons: [
            //button 1
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "CLOSE",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
            //button 2
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "DONE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _nodeText6,
          footerBuilder: (_) =>
          const PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('Custom Footer'),
                  ))),
        ),
      ],
    );
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
      drawer: const TopBarDrawer(title: 'Contacte',),
      body: KeyboardActions(
        config: _buildConfig(context),
        tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopBarMenu(),
              SizedBox(
                height: 580,
                child: ListView(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  children: [
                    for(var message in messages)
                      MessageItem(message: message, type: message.user?.email==user?.email?"sent":"received")
                  ],
                ),
              ),
              NewMessageTextField(receiver: widget.receiver, addMessage: callback, user: user, scrollDown: scrollDown, nodeText: _nodeText1)
            ],
          ),
        ),
      ),
    );
  }
}