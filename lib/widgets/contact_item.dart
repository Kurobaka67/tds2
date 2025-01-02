import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PrivateMessageScreen(receiver: widget.user)));
      },
      child: Container(
        height: 70,
        width: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5
        ),
        child: Center(
            child: Row(
              children: [
                Text(widget.user.firstname)
              ],
            )
        ),
      ),
    );
  }
}