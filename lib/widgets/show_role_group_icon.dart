import 'package:flutter/material.dart';
import 'package:tds2/models/group_model.dart';

import '../screens/screens.dart';

class ShowRoleGroupIcon extends StatefulWidget {
  final int? roleGroup;

  const ShowRoleGroupIcon({
    super.key,
    required this.roleGroup
  });

  @override
  State<ShowRoleGroupIcon> createState() => _ShowRoleGroupIconState();
}

class _ShowRoleGroupIconState extends State<ShowRoleGroupIcon> {
  late IconData iconData;

  void initIcon() {
    switch(widget.roleGroup){
      case 0 : iconData = Icons.favorite_border;
      case 1 : iconData = Icons.star_border_outlined;
      default : iconData = Icons.face;
    }
  }

  @override
  void initState() {
    super.initState();
    initIcon();
  }

  @override
  Widget build(BuildContext context) {

    return Icon(iconData);
  }
}