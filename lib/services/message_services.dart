import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:tds2/models/group_model.dart';

List<GroupModel> messages = [];

class MessageService {
  Future<void> getMessages() async {
    try {
      var response = await rootBundle.loadString('assets/data/messages.json');
      if (response.isNotEmpty) {
        messages = groupModelFromJson(response);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}