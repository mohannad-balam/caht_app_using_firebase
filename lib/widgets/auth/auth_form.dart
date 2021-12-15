import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username, File image,
      bool isLogin, BuildContext context) submitFunc;

  final bool _isLoading;

  AuthForm(this.submitFunc, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _username = "";
  File _userImageFile;

  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImageFile == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Pick an Image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFunc(
          _email.trim(), _password.trim(), _username.trim(), _userImageFile ,_isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: ValueKey('email'),
                  validator: (val) {
                    if (val.isEmpty || !val.contains("@")) {
                      return "Please Enter a Valid Email Address";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => _email = val,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address"),
                ),
                if (!_isLogin)
                  TextFormField(
                    autocorrect: true,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.words,
                    key: ValueKey('username'),
                    validator: (val) {
                      if (val.isEmpty || val.length < 4) {
                        return "Please Enter At Least 4 Characters";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => _username = val,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (val) {
                    if (val.isEmpty || val.length < 7) {
                      return "Password Must Be At Least 7 Characters";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => _password = val,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget._isLoading)
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                if (!widget._isLoading) // if not loading
                  RaisedButton(
                    child: Text(_isLogin ? "Login" : "SignUp"),
                    onPressed: _submit,
                  ),
                if (!widget._isLoading) // if not loading
                  FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? "Create New Account"
                          : "I Already Have An Account"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
