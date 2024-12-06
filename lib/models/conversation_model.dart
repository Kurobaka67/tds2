import 'dart:convert';

import 'package:tds2/models/user_model.dart';

List<ConversationModel> conversationModelFromJson(String str) =>
    List<ConversationModel>.from(json.decode(str).map((x) => ConversationModel.fromJson(x)));

String conversationModelToJson(List<ConversationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConversationModel {
  ConversationModel({
    required this.contact
  });

  UserModel contact;

  factory ConversationModel.fromJson(Map<String, dynamic> json) => ConversationModel(
    contact: json["contact"],
  );

  Map<String, dynamic> toJson() => {
    "contact": contact,
  };
}