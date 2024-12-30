import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
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
  String roleItemSelected = 'Amis';
  var roleItems = [
    'Amis',
    'Amis proches',
  ];


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

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  final FocusNode _nodeText6 = FocusNode();

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
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
              child: Padding(
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
                    content: Text("Custom Action"),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text("OK"),
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
                  padding: EdgeInsets.all(8.0),
                  child: Text(
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
                  padding: EdgeInsets.all(8.0),
                  child: Text(
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
          footerBuilder: (_) => PreferredSize(
              child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('Custom Footer'),
                  )),
              preferredSize: Size.fromHeight(40)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SizedBox(
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(),
                  const Spacer(),
                  DropdownButton(
                    value: roleItemSelected,
                    items: roleItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        roleItemSelected = newValue!;
                      });
                    },
                  )
                ],
              ),
              Row(
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
                      keyboardType: TextInputType.number,
                      focusNode: _nodeText1,
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
              ),
            ],
          )
      ),
    );
  }
}