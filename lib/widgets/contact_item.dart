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
                  Text(widget.user.firstname)
                ],
              )
          ),
        ),
      ),
    );
  }
}