import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:tds2/models/group_model.dart';
import 'package:tds2/models/message_model.dart';

import 'package:http/http.dart' as http;
import 'package:tds2/my_globals.dart' as globals;

class MessageService {
  Future<List<MessageModel>?> getAllMessagesByGroup(int groupId, int userId) async {
      try {
        var client = http.Client();
        var uri = Uri.parse('${globals.url}/messages/group/$groupId');
        var response = await client.post(uri,
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "userId": userId,
            }));
        if (response.statusCode == 200) {
          return messageModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
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

  Future<List<MessageModel>?> getMessageByUser(int userId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/messages/$userId');
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return messageModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
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

  Future<bool> createNewPrivateMessage(String content, int id) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/messages');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "content": content,
            "userId": id,
          }));
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

  Future<bool> createNewGroupMessage(String content, int id, int groupId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/message/group');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "content": content,
            "userId": id,
            "groupId": groupId,
          }));
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