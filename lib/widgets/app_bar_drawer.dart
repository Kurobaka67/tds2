import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/models/group_model.dart';
import 'package:tds2/models/notification_model.dart';
import 'package:tds2/screens/screens.dart';
import '../models/user_model.dart';

class TopBarDrawer extends StatefulWidget {
  final String title;
  final List<UserModel>? users;
  final List<GroupModel>? groups;

  const TopBarDrawer({
    super.key,
    required this.title,
    this.users,
    this.groups
  });

  @override
  State<TopBarDrawer> createState() => _TopBarDrawerState();
}

class _TopBarDrawerState extends State<TopBarDrawer> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  List<NotificationModel> notifications = [];
  String firstname = "";
  String lastname = "";
  String? pictureBase64String;

  Future<void> initializeSharedPreferences() async {
    final String fn = await prefs?.getString('firstname') ?? '';
    final String ln = await prefs?.getString('lastname') ?? '';

    String? pic;
    var r = await prefs?.getString('picture');
    if(r != null && r.isNotEmpty){
      pic = await prefs?.getString('picture');
    }

    setState(() {
      firstname = fn;
      lastname = ln;
      pictureBase64String = pic;
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

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
              child: Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: CircleAvatar(
                          backgroundImage: pictureBase64String != null?MemoryImage(base64Decode(pictureBase64String!)):const NetworkImage("https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg"),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 25,
                        width: 90,
                        child: ElevatedButton(
                            onPressed: () {
                              _navigateToProfileScreen(context);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 0)
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Text("Modifier"),
                                  Spacer(),
                                  Icon(Icons.mode_edit, size: 18,)
                                ],
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: 150,
                      child: Column(
                        children: [
                          Flexible(
                              child: Text(
                                  firstname,
                                  style: TextStyle(
                                      color: theme.colorScheme.onPrimary
                                  ),
                                  overflow: TextOverflow.ellipsis
                              )
                          ),
                          Flexible(
                              child: Text(
                                  lastname,
                                  style: TextStyle(
                                      color: theme.colorScheme.onPrimary
                                  ),
                                  overflow: TextOverflow.ellipsis
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: MenuAnchor(
                        builder: (BuildContext context, MenuController controller,
                            Widget? child) {
                          return IconButton(
                            onPressed: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            icon: Icon(
                              Icons.notifications,
                              color: theme.colorScheme.onPrimary,
                            ),
                            tooltip: 'Notifications',
                          );
                        },
                        menuChildren: [

                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ),
          Center(
              child: Text(widget.title,
                style: const TextStyle(
                  fontSize: 20
                ),
              )
          ),
          switch (widget.users?.length!=null){
          true => ListView.separated(
              shrinkWrap: true,
              itemBuilder:  (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                        backgroundImage: widget.users![index].pictureEncoded != null?MemoryImage(base64Decode(widget.users![index].pictureEncoded!)):const NetworkImage("https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg"),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(widget.users![index].firstname),
                      ],
                    ),
                  ],
                ),
              ),
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
              ),
              itemCount: widget.users?.length!=null?widget.users!.length:0
          ),
        false => ListView.separated(
            shrinkWrap: true,
            itemBuilder:  (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Icon(Icons.group),
                  const Spacer(),
                  Text(widget.groups![index].name),
                ],
              ),
            ),
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black,
            ),
            itemCount: widget.groups?.length!=null?widget.groups!.length:0
        ),
        }
        ],
      ),
    );
  }

  void _navigateToProfileScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }
}

