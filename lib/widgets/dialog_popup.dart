import 'package:flutter/material.dart';
import 'package:tds2/models/group_model.dart';

import '../screens/screens.dart';

class DialogPopUp extends StatefulWidget {
  final String title;
  final String content;

  const DialogPopUp({
    super.key,
    required this.title,
    required this.content
  });

  @override
  State<DialogPopUp> createState() => _DialogPopUpState();
}

class _DialogPopUpState extends State<DialogPopUp> {
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
        title: const Text("Rejoindre un groupe"),
        content: const Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text("Code du groupe : ")
              ),
              TextField()
            ]
        ),
        actions: [
          TextButton(
            child: const Text("Annuler"),
              onPressed:  () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Confirmer"),
            onPressed:  () {

            },
          ),
        ],
      );
    }
}