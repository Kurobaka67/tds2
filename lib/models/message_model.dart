import 'dart:convert';

import 'package:tds2/models/user_model.dart';

List<MessageModel> messageModelFromJson(String str) =>
    List<MessageModel>.from(json.decode(str).map((x) => MessageModel.fromJson(x)));

String messageModelToJson(List<MessageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessageModel {
  MessageModel({
    this.user,
    required this.content,
    required this.date,
    this.role,
  });

  UserModel? user;
  String content;
  DateTime date;
  int? role;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    user: UserModel(id: json["id"], firstname: json["firstname"], lastname: json["lastname"], email: json["email"], role: json["role"], hashPassword: json["password"]),
    content: json["content"],
    date: DateTime.parse(json["date"]),
    role: json["sent_role"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "content": content,
    "date": date,
    "sent_role": role,
  };
}