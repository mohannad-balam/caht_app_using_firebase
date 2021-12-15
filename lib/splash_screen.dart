import 'dart:io';

import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  File _file = File('assets/splashscreen.png');

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ChatScreen();
                } else {
                  return AuthScreen();
                }
              }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_outlined,
                color: Colors.teal,
                size: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "ChatBook!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Colors.teal.shade900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
