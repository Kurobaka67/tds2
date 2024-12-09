import 'dart:convert';

import 'package:tds2/models/user_model.dart';

List<GroupModel> groupModelFromJson(String str) =>
    List<GroupModel>.from(json.decode(str).map((x) => GroupModel.fromJson(x)));

String groupModelToJson(List<GroupModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupModel {
  GroupModel({
    required this.name,
    required this.moderator,
    required this.archived
  });

  String name;
  UserModel moderator;
  bool archived;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    name: json["name"],
    moderator: UserModel(firstname: json["firstname"], lastname: json["lastname"], email: json["email"], role: json["role"]),
    archived: json["archived"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "moderator": moderator,
    "archived": archived,
  };
}