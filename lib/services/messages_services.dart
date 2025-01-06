import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:tds2/models/group_model.dart';
import 'package:tds2/models/message_model.dart';

import 'package:http/http.dart' as http;
import 'package:tds2/my_globals.dart' as globals;

class MessageService {
  Future<List<MessageModel>?> getAllMessagesByGroup(int groupId, int userId, int? role) async {
      try {
        var client = http.Client();
        var uri = Uri.parse('${globals.url}/messages/group/$groupId');
        var response = await client.post(uri,
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "userId": userId,
              "groupRole": role
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

  Future<List<MessageModel>?> getPrivateMessage(int senderId, int receiverId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/messages/private');
      print('ok');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "senderId": senderId,
            "receiverId": receiverId
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

  Future<bool> createNewPrivateMessage(String content, int senderId, int receiverId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/messages');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "content": content,
            "senderId": senderId,
            "receiverId": receiverId
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

  Future<bool> createNewGroupMessage(String content, int id, int groupId, int roleGroup) async {
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