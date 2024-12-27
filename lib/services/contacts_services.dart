import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:tds2/models/group_model.dart';

import 'package:http/http.dart' as http;
import 'package:tds2/my_globals.dart' as globals;

import '../models/contact_model.dart';

class GroupService {
  Future<List<ContactModel>?> getAllContacts() async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/contacts');
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return contactModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return null;
    }
    catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<ContactModel>?> getContactsByUser(int userId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/contacts/user/$userId');
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return contactModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return null;
    }
    catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<ContactModel>?> addContactsToUser(int userId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/contacts/user');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "userId": userId,
          }));
      if (response.statusCode == 200) {
        return contactModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return null;
    }
    catch (e) {
      log(e.toString());
    }
    return null;
  }
}