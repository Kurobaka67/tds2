import 'package:flutter/material.dart';
import 'package:tds2/models/group_model.dart';

import '../screens/screens.dart';

class OptionUserOnClick extends StatefulWidget {

  const OptionUserOnClick({
    super.key,
  });

  @override
  State<OptionUserOnClick> createState() => _OptionUserOnClickState();
}

class _OptionUserOnClickState extends State<OptionUserOnClick> {

  

  @override
  Widget build(BuildContext context) {

    return PopupMenuButton(

      itemBuilder: (BuildContext bc) {
        return const [
          PopupMenuItem(
            child: Text("Hello"),
            value: '/hello',
          ),
          PopupMenuItem(
            child: Text("About"),
            value: '/about',
          ),
          PopupMenuItem(
            child: Text("Contact"),
            value: '/contact',
          )
        ];
      },
    );
  }
}