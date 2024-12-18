import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:tds2/models/group_model.dart';

import 'package:http/http.dart' as http;
import 'package:tds2/my_globals.dart' as globals;

class GroupService {
  Future<List<GroupModel>?> getAllGroups() async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/groups');
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return groupModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
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

  Future<List<GroupModel>?> getGroupsByUser(String userEmail) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/groups/user/$userEmail');
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return groupModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
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

  Future<bool> createGroup() async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/group');
      var response = await client.post(uri);
      if (response.statusCode == 200) {
        return true;
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      return false;
    }
    catch (e) {
      log(e.toString());
    }
    return false;
  }
}