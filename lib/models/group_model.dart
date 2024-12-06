import 'dart:convert';

import 'package:tds2/models/user_model.dart';

List<GroupModel> groupModelFromJson(String str) =>
    List<GroupModel>.from(json.decode(str).map((x) => GroupModel.fromJson(x)));

String groupModelToJson(List<GroupModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupModel {
  GroupModel({
    required this.name,
    required this.moderator
  });

  String name;
  UserModel moderator;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    name: json["name"],
    moderator: json["moderator"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "moderator": moderator,
  };
}