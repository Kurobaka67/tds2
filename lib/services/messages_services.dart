import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:tds2/models/group_model.dart';
import 'package:tds2/models/message_model.dart';

import 'package:http/http.dart' as http;
import 'package:tds2/my_globals.dart' as globals;

class MessageService {
  Future<List<MessageModel>?> getAllMessagesByGroup(int groupId) async {
      try {
        var client = http.Client();
        var uri = Uri.parse('${globals.url}/messages/group/$groupId');
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
}