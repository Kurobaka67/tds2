import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:tds2/models/user_model.dart';
import 'package:tds2/my_globals.dart' as globals;

import 'firebase_api.dart';

class UsersService {
  Future<List<UserModel>?> login(String email, String password) async {
    try {
      var token = await FirebaseApi().init();
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/login');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "email": email,
            "password": password,
            "token": token,
          }));
      if (response.statusCode == 200) {
        return userModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
      }
      else{
        return null;
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return null;
    }
    catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> logout(String email) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/logout');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "email": email,
          }));
      if (response.statusCode == 204) {
        return true;
      }
      else{
        return false;
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return false;
    }
    catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> signin(String firstname, String lastname, String email, String password) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/user');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "email": email,
            "firstname": firstname,
            "lastname": lastname,
            "password": password,
          }));
      if (response.statusCode == 200) {
        return true;
      }
      else{
        return false;
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return false;
    }
    catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<UserModel>?> getUserByEmail(String email) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/user/$email');
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return userModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
      }
      else{
        return null;
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return null;
    }
    catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<List<UserModel>?> getUserByGroup(int groupId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/users/group/$groupId');
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return userModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
      }
      else{
        return null;
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return null;
    }
    catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> editUser(String firstname, String lastname, String email, String? pictureEncoded) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/user');
      var response = await client.put(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "email": email,
            "firstname": firstname,
            "lastname": lastname,
            "picture": pictureEncoded
          }));
      if (response.statusCode == 200) {
        return true;
      }
      else{
        return false;
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return false;
    }
    catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> changeRoleUser(int userId, String role) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/user/role/$userId');
      var response = await client.put(uri,
          headers: {
            "Content-Type": "application/json",
            
          },
          body: jsonEncode({
            "role": role,
          }));
      if (response.statusCode == 200) {
        return true;
      }
      else{
        return false;
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return false;
    }
    catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteAccount(int userId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/user/$userId');
      var response = await client.delete(uri);
      if (response.statusCode == 200) {
        return true;
      }
      else{
        return false;
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return false;
    }
    catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> enableNotif(int userId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/user/enable-notif/$userId');
      var response = await client.put(uri);
      if (response.statusCode == 200) {
        return true;
      }
      else{
        return false;
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return false;
    }
    catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> disableNotif(int userId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/user/disable-notif/$userId');
      var response = await client.put(uri);
      if (response.statusCode == 200) {
        return true;
      }
      else{
        return false;
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return false;
    }
    catch (e) {
      log(e.toString());
      return false;
    }
  }

}