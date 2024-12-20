import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/models/group_model.dart';
import 'package:tds2/models/message_model.dart';
import 'package:tds2/models/user_model.dart';
import 'package:tds2/services/messages_services.dart';

import '../screens/screens.dart';

class NewMessageTextField extends StatefulWidget {
  final GroupModel group;
  final UserModel? user;
  final void Function(MessageModel) addMessage;
  final void Function() scrollDown;

  const NewMessageTextField({
    super.key,
    required this.group,
    required this.user,
    required this.addMessage,
    required this.scrollDown
  });

  @override
  State<NewMessageTextField> createState() => _NewMessageTextFieldState();
}

class _NewMessageTextFieldState extends State<NewMessageTextField> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  TextEditingController newMessageController = TextEditingController();
  List<File> filesImport = [];
  bool isLoading = false;
  String newMessage = "";
  int userId = -1;

  Future<void> sendMessage() async {
    if(newMessageController.text.isNotEmpty && userId > 0) {
      setState(() {
        isLoading = true;
        newMessage = newMessageController.text;
      });
      var result = (await MessageService().createNewGroupMessage(newMessage, userId, widget.group.id));
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

    return SizedBox(
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
                      pickFile();
                      //widget.scrollDown();
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
                      sendMessage();
                    },
                    child: const Icon(Icons.send)
                ),
              )
            ],
          )
      ),
    );
  }
}