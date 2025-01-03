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
      child: SizedBox(
        width: 300,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.topLeft,
                  child: Text('${widget.message.user!.firstname} ${widget.message.user!.lastname}', style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface
                    ),
                  )
              ),
            ),
            ClipPath(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: widget.type=="sent"?
                    const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)
                    )
                    :const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                    ),
                ),
                color: theme.colorScheme.primaryFixed,
                child: SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(widget.message.content, style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.onPrimaryFixed
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(timeFormatter.format(widget.message.date), style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.scrim
                          ),),
                        )
                      ],
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      )
    );
  }
}

class CustomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = new Path();
    path.lineTo(size.width - 50, 0);
    path.lineTo(size.width - 90, size.height / 2);
    path.lineTo(size.width - 50, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}