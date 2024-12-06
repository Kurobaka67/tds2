import 'package:flutter/material.dart';
import 'package:tds2/models/group_model.dart';
import 'package:tds2/models/notification_model.dart';
import '../models/user_model.dart';

class TopBarDrawer extends StatefulWidget {
  final String title;
  final UserModel user;
  final List<UserModel>? users;
  final List<GroupModel>? groups;

  const TopBarDrawer({
    super.key,
    required this.title,
    required this.user,
    this.users,
    this.groups
  });

  @override
  State<TopBarDrawer> createState() => _TopBarDrawerState();
}

class _TopBarDrawerState extends State<TopBarDrawer> {
  List<NotificationModel> notifications = [];

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
              padding: const EdgeInsets.only(left: 10, right: 0, top: 0, bottom: 20),
              child: Row(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 80,
                        width: 80,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage("https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg"),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 25,
                        width: 80,
                        child: ElevatedButton(
                            onPressed: () {

                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 0)
                            ),
                            child: const Text("Modifier")
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
                                  widget.user.firstname,
                                  style: TextStyle(
                                      color: theme.colorScheme.onPrimary
                                  ),
                                  overflow: TextOverflow.ellipsis
                              )
                          ),
                          Flexible(
                              child: Text(
                                  widget.user.lastname,
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
                    const Icon(Icons.person),
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
}

