import 'dart:convert';

import 'package:tds2/models/user_model.dart';

List<GroupModel> groupModelFromJson(String str) =>
    List<GroupModel>.from(json.decode(str).map((x) => GroupModel.fromJson(x)));

String groupModelToJson(List<GroupModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupModel {
  GroupModel({
    required this.id,
    required this.name,
    required this.moderator,
    required this.archived
  });

  int id;
  String name;
  UserModel moderator;
  bool archived;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json["group_id"],
    name: json["name"],
    moderator: UserModel(id: json["id"], firstname: json["firstname"], lastname: json["lastname"], email: json["email"], role: json["role"], hashPassword: json["password"]),
    archived: json["archived"],
  );

  Map<String, dynamic> toJson() => {
    "group_id": id,
    "name": name,
    "moderator": moderator,
    "archived": archived,
  };
}