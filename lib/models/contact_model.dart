import 'dart:convert';

import 'package:tds2/models/user_model.dart';

List<ContactModel> contactModelFromJson(String str) =>
    List<ContactModel>.from(json.decode(str).map((x) => ContactModel.fromJson(x)));

String contactModelToJson(List<ContactModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ContactModel {
  ContactModel({
    required this.contact,
  });

  UserModel contact;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    contact: UserModel(id: json["id"], firstname: json["firstname"], lastname: json["lastname"], email: json["email"], role: json["role"], hashPassword: json["password"]),
  );

  Map<String, dynamic> toJson() => {
    "contact": contact,
  };
}