import 'package:chat_app/widgets/chat/mesaages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatBook Room"),
        centerTitle: true,
        actions: [
          DropdownButton(
            underline: Container(),
            iconEnabledColor: Colors.teal,
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.teal.shade900,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "About Me!",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                value: 'aboutMe',
              ),
              DropdownMenuItem(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.teal.shade900,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                //so when we sign out the streamBuilder gonna update and know that
                //the snapShot no more hasData then it will push us to the auth screen
                // and the opposite is correct
                FirebaseAuth.instance.signOut();
              } else if (itemIdentifier == 'aboutMe') {
                return showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text("About Me!"),
                          content: Text(
                            "This Simple Chat App Was Developed By Mohannad Fathi Balam\n\nIf You Wanna Know More About me or Wanna Make Project Requests!\nFeel Free To DM Me On\nTelegram & Any Platform : @Mohannad_Balam",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  "Thank You!",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ))
                          ],
                          backgroundColor: Colors.teal.shade900,
                        ));
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
