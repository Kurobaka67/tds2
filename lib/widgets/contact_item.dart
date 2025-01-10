import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/models/user_model.dart';
import 'package:tds2/screens/private_message_screen.dart';

import '../screens/screens.dart';

class ContactItem extends StatefulWidget {
  final UserModel user;

  const ContactItem({
    super.key,
    required this.user
  });

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  String? pictureBase64String;

  Future<void> initializeSharedPreferences() async {
    String? pic;
    var r = await prefs?.getString('picture');
    if(r != null && r.isNotEmpty){
      pic = await prefs?.getString('picture');
    }

    setState(() {
      pictureBase64String = pic;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivateMessageScreen(receiver: widget.user)));
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          height: 70,
          width: 100,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryFixed,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5
          ),
          child: Center(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: pictureBase64String != null?MemoryImage(base64Decode(pictureBase64String!)):const NetworkImage("https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg"),
                  ),
                  const SizedBox(width: 50),
                  Text(widget.user.firstname)
                ],
              )
          ),
        ),
      ),
    );
  }
}