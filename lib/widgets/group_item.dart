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

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupMessageScreen(group: widget.group)));
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
                Text(widget.group.name)
              ],
            )
        ),
      ),
    );
  }
}