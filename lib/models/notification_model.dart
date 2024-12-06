import 'dart:convert';

import 'package:tds2/models/user_model.dart';

List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  NotificationModel({
    required this.title,
    required this.description,
    this.btn1,
    this.btn2
  });

  String title;
  String description;
  String? btn1;
  String? btn2;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    title: json["title"],
    description: json["description"],
    btn1: json["btn1"],
    btn2: json["btn2"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "btn1": btn1,
    "btn2": btn2,
  };
}