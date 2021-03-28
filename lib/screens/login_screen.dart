// Packages:
import 'package:flutter/material.dart';

// Screens:

// Components:
import 'package:flash_chat_latest/components/auth_button.dart';
import 'package:flash_chat_latest/components/text_input.dart';
import 'package:flash_chat_latest/components/password_input.dart';

// Helpers:

// Utilities:
import 'package:flash_chat_latest/utilities/constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'flash_logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),

            // User Input: Email
            TextInput(
              hintText: 'Enter your email',
            ),

            SizedBox(
              height: 8.0,
            ),

            // User Input: password
            PasswordInput(
              hintText: 'Enter your password',
            ),

            SizedBox(
              height: 24.0,
            ),

            // Login Screen button
            Hero(
              tag: 'login_button',
              child: AuthButton(
                color: Colors.lightBlueAccent,
                onPressed: () {},
                label: 'Log in',
              ),
            )
          ],
        ),
      ),
    );
  }
}
