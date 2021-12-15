import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  String _enteredMessage = "";

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection("chat").add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'username': userData['username'],
      'userId': user.uid,
      'userImage': userData['imageUrl'],
    });
    _controller.clear();
    setState(() {
      _enteredMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            autocorrect: true,
            enableSuggestions: true,
            textCapitalization: TextCapitalization.sentences,
            controller: _controller,
            decoration: InputDecoration(hintText: "Send a Message..."),
            onChanged: (val) {
              setState(() {
                _enteredMessage = val;
              });
            },
          )),
          IconButton(
            disabledColor: Colors.teal[200],
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
