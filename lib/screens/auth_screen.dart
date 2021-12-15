
import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  void _submitAuthScreen(String email, String password, String username, File image,
      bool isLogin, BuildContext innerContext) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance.ref().child('users_image').child(authResult.user.uid+'jpg');

        await ref.putFile(image);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'email' : email,
          'username' : username,
          'password' : password,
          'imageUrl' : url,
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = "an Error Occurred";

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong Email Or Password For That User.';
      }

      Scaffold.of(innerContext).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(innerContext).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });

    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade800,
        centerTitle: true,
        title: Text(
          "ChatBook Login Form",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthScreen , _isLoading),
    );
  }
}
