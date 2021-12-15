import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.username, this.userImage, this.isMe,
      {this.key});

  final Key key;
  final String message;
  final String username;
  final String userImage;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.teal : Colors.grey[300],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                    bottomLeft:
                        !isMe ? Radius.circular(0) : Radius.circular(14),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(14)),
              ),
              width: 170,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: isMe ? Colors.white : Colors.teal[400]),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: isMe ? Colors.white : Colors.teal[400]),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: isMe ? 150 : null,
          left: !isMe? 150 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
