import 'dart:convert';
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

import '../models/group_role_model.dart';
import '../screens/screens.dart';
import 'package:tds2/my_globals.dart' as globals;

class NewMessageTextField extends StatefulWidget {
  final GroupModel? group;
  final UserModel? user;
  final UserModel? receiver;
  final void Function(MessageModel) addMessage;
  final void Function() scrollDown;

  const NewMessageTextField({
    super.key,
    this.group,
    this.receiver,
    required this.user,
    required this.addMessage,
    required this.scrollDown,
  });

  @override
  State<NewMessageTextField> createState() => _NewMessageTextFieldState();
}

class _NewMessageTextFieldState extends State<NewMessageTextField> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  TextEditingController newMessageController = TextEditingController();
  File? fileImportSelected;
  String? fileBase64String;
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
        if(fileBase64String != null){
          result = (await MessageService().createNewGroupMessage(newMessage, userId, widget.group!.id, roleItemSelected, fileBase64String));
        }
        else{
          result = (await MessageService().createNewGroupMessage(newMessage, userId, widget.group!.id, roleItemSelected, null));
        }
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
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        fileImportSelected = files[0];
      });
      var _bytes = (await fileImportSelected?.readAsBytes());
      setState(() {
        fileBase64String = base64.encode(_bytes as List<int>);
      });
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
      height: 120,
      width: MediaQuery.of(context).size.width,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  if(fileImportSelected != null)
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black.withOpacity(0.5))
                      ),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.insert_drive_file)
                      ),
                    ),
                  const Spacer(),
                  DropdownButton(
                    value: roleItemSelected,
                    items: roleItems.map((GroupRoleModel items) {
                      return DropdownMenuItem(
                        value: items.value,
                        child: Text(items.text),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
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
                          backgroundColor: theme.colorScheme.secondary.withOpacity(0.6),
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
                      onTap: () {
                        globals.isBottomSheetShow = true;
                        showBottomSheet(
                            context: context,
                            builder: (context) => SizedBox(
                              height: 100,
                              child: Row(
                                children: [
                                  Container(),
                                  const Spacer(),
                                  DropdownButton(
                                    value: roleItemSelected,
                                    items: roleItems.map((GroupRoleModel items) {
                                      return DropdownMenuItem(
                                        value: items.value,
                                        child: Text(items.text),
                                      );
                                    }).toList(),
                                    onChanged: (int? newValue) {
                                      setState(() {
                                        roleItemSelected = newValue!;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ));
                      },
                      keyboardType: TextInputType.text,
                      controller: newMessageController,
                      decoration: InputDecoration(
                          fillColor: theme.colorScheme.primary.withOpacity(0.4),
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
                          backgroundColor: theme.colorScheme.secondary.withOpacity(0.6),
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