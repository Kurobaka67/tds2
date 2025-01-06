import 'package:flutter/material.dart';
import 'package:tds2/models/group_model.dart';

import '../screens/screens.dart';

class GroupItem extends StatefulWidget {
  final GroupModel group;

  const GroupItem({
    super.key,
    required this.group
  });

  @override
  State<GroupItem> createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupMessageScreen(group: widget.group)));
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
                  Text(widget.group.name, style: TextStyle(color: theme.colorScheme.onPrimaryFixed),)
                ],
              )
          ),
        ),
      ),
    );
  }
}