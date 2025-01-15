import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:tds2/models/file_model.dart';
import 'package:tds2/models/group_model.dart';

import 'package:http/http.dart' as http;
import 'package:tds2/my_globals.dart' as globals;

class FileService {
  Future<bool> uploadFile(String base64) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/file/upload');
      var response = await client.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "file": base64,
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

  Future<List<FileModel>?> downloadFile(int fileId) async {
    try {
      var client = http.Client();
      var uri = Uri.parse('${globals.url}/groups/user/$fileId');
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        return fileModelFromJson(const Utf8Decoder().convert(response.bodyBytes));
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