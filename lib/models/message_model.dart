import 'dart:convert';

import 'package:tds2/models/user_model.dart';

List<MessageModel> messageModelFromJson(String str) =>
    List<MessageModel>.from(json.decode(str).map((x) => MessageModel.fromJson(x)));

String messageModelToJson(List<MessageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessageModel {
  MessageModel({
    required this.user,
    required this.content,
    required this.date
  });

  UserModel user;
  String content;
  DateTime date;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    user: json["user"],
    content: json["content"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "content": content,
    "date": date,
  };
}