import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/models/group_model.dart';
import 'package:tds2/models/message_model.dart';
import 'package:tds2/models/user_model.dart';
import 'package:tds2/services/messages_services.dart';

import '../models/group_role_model.dart';
import '../screens/screens.dart';

class KeyboardTest extends StatefulWidget {
  final GroupModel? group;
  final UserModel? user;
  final UserModel? receiver;
  final void Function(MessageModel) addMessage;
  final void Function() scrollDown;
  final FocusNode nodeText;

  const KeyboardTest({
    super.key,
    this.group,
    this.receiver,
    required this.user,
    required this.addMessage,
    required this.scrollDown,
    required this.nodeText
  });

  @override
  State<KeyboardTest> createState() => _KeyboardTestState();
}

class _KeyboardTestState extends State<KeyboardTest> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  TextEditingController newMessageController = TextEditingController();
  List<File> filesImport = [];
  bool isLoading = false;
  String newMessage = "";
  int userId = -1;
  int roleItemSelected = 2;
  List<GroupRoleModel> roleItems = [
    GroupRoleModel(text: "Amis", value: 2),
    GroupRoleModel(text: "Amis proche", value: 1),
  ];


  Future<void> sendMessage() async {
    if(newMessageController.text.isNotEmpty && userId > 0) {
      setState(() {
        isLoading = true;
        newMessage = newMessageController.text;
      });
      var result;
      if(widget.group != null){
        result = (await MessageService().createNewGroupMessage(newMessage, userId, widget.group!.id, roleItemSelected));
      }
      else{
        result = (await MessageService().createNewPrivateMessage(newMessage, userId, widget.receiver!.id));
      }
      setState(() {
        isLoading = false;
      });
      if(result){
        newMessageController.clear();
        widget.addMessage(MessageModel(content: newMessage, date: DateTime.now(), user: widget.user));
        widget.scrollDown();
      }
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      files.forEach((element) => filesImport.add(element));
      //print(filesImport);
    } else {
      print("No file selected");
    }
  }

  Future<void> initializeSharedPreferences() async {
    final int id = await prefs?.getInt('id') ?? -1;
    setState(() {
      userId = id;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.blue,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Keyboard Attachable demo")),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: FooterLayout(
          footer: KeyboardAttachableFooter(),
          child: ColorsList(),
        ),
      ),
    );
  }

  KeyboardAttachableFooter() {}

  ColorsList() {}
}