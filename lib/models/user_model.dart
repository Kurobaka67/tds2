import 'dart:convert';
import 'dart:ffi';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.role,
    required this.hashPassword
  });

  String firstname;
  String lastname;
  String email;
  String role;
  String hashPassword;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    role: json["role"],
    hashPassword: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "role": role,
    "password": hashPassword,
  };
}