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
        print(response.bodyBytes);
        //return requestModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
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

  Future<List<GroupModel>?> getGroupsByUser(int userId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/groups/user/$userId');
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

  Future<void> createGroup() async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/group');
      var response = await client.post(uri);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(groupModelFromJson(const Utf8Decoder().convert(response.bodyBytes)));
        //return requestModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
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