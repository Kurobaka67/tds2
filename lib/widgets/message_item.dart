import 'package:flutter/material.dart';
import 'package:tds2/models/message_model.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatefulWidget {
  final MessageModel message;
  final String type;

  const MessageItem({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  final timeFormatter = DateFormat('dd/MM HH:mm');


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Align(
      alignment: widget.type=="sent"?Alignment.centerRight:Alignment.centerLeft,
      child: Column(
        children: [
          Text(widget.message.user!.firstname),
          Card(
            color: theme.colorScheme.secondary,
            child: SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(widget.message.content, style: TextStyle(

                        fontSize: 18,
                        color: theme.colorScheme.onSecondary
                      ),
                    ),
                    Text(timeFormatter.format(widget.message.date), style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.scrim
                    ),)
                  ],
                ),
              ),
            )
          ),
        ],
      )
    );
  }
}