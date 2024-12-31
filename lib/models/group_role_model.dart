import 'dart:convert';

import 'package:tds2/models/user_model.dart';

class GroupRoleModel {
  GroupRoleModel({
    required this.text,
    required this.value,
  });

  String text;
  int value;
}