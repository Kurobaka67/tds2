import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tds2/models/group_model.dart';

import 'package:http/http.dart' as http;
import 'package:tds2/models/user_model.dart';
import 'package:tds2/my_globals.dart' as globals;

class UsersService {
  Future<List<UserModel>?> login(String email, String password) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/login');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "email": email,
            "password": password,
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

  Future<bool> editUser(String firstname, String lastname, String email) async {
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
}