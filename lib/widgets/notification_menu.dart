import 'package:flutter/material.dart';
import 'package:tds2/models/group_model.dart';

import '../screens/screens.dart';

class NotificationMenu extends StatefulWidget {

  const NotificationMenu({
    super.key,
  });

  @override
  State<NotificationMenu> createState() => _NotificationMenuState();
}

class _NotificationMenuState extends State<NotificationMenu> {
  bool isLoading = false;

  Future<void> initNotif() async{
    setState(() {
      isLoading = true;
    });
    //get notif
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotif();
  }

  @override
  Widget build(BuildContext context) {

    return PopupMenuButton(

      itemBuilder: (BuildContext bc) {
        return const [

        ];
      },
    );
  }
}